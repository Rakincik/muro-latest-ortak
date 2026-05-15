import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, act, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { AuthProvider, useAuth } from '@/contexts/AuthContext'
import React from 'react'

// Mock api module
vi.mock('@/lib/api', () => ({
    authApi: {
        login: vi.fn(),
        me: vi.fn(),
    },
    ApiError: class ApiError extends Error {
        statusCode: number
        constructor(message: string, statusCode: number) {
            super(message)
            this.statusCode = statusCode
        }
    },
}))

import { authApi } from '@/lib/api'
const mockLogin = vi.mocked(authApi.login)
const mockMe = vi.mocked(authApi.me)

// AuthContext'i test etmek için helper component
function TestConsumer() {
    const { user, token, isLoading, login, logout, currentTenantId } = useAuth()
    return (
        <div>
            <span data-testid="loading">{isLoading ? 'loading' : 'ready'}</span>
            <span data-testid="user">{user?.email || 'none'}</span>
            <span data-testid="token">{token || 'none'}</span>
            <span data-testid="tenant">{currentTenantId || 'none'}</span>
            <button data-testid="login-btn" onClick={() => login('admin@test.com', 'pass')}>Login</button>
            <button data-testid="logout-btn" onClick={() => logout()}>Logout</button>
        </div>
    )
}

describe('AuthContext', () => {
    beforeEach(() => {
        vi.clearAllMocks()
        localStorage.clear()
    })

    // ── 1. Başlangıçta loading → ready ─────────────────────────────────────────
    it('should start loading and become ready', async () => {
        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )

        await waitFor(() => {
            expect(screen.getByTestId('loading').textContent).toBe('ready')
        })
        expect(screen.getByTestId('user').textContent).toBe('none')
    })

    // ── 2. Login başarılı → user + token set edilmeli ──────────────────────────
    it('should set user and token after successful login', async () => {
        mockLogin.mockResolvedValueOnce({
            token: 'jwt-123',
            refreshToken: '',
            expiresAt: '',
            user: {
                id: '1', firstName: 'Admin', lastName: 'User',
                email: 'admin@test.com', phone: null, role: 'Admin',
                studentType: null, demoExpiresAt: null, lastLoginAt: null, groupNames: [], isActive: true,
                createdAt: '', tenants: [{ tenantId: 't1', tenantName: 'Test', tenantCode: 'test', role: 'Admin', status: 'Active' }]
            }
        })

        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )

        await waitFor(() => expect(screen.getByTestId('loading').textContent).toBe('ready'))

        await act(async () => {
            screen.getByTestId('login-btn').click()
        })

        expect(screen.getByTestId('user').textContent).toBe('admin@test.com')
        expect(screen.getByTestId('token').textContent).toBe('jwt-123')
        expect(screen.getByTestId('tenant').textContent).toBe('t1')
        expect(localStorage.getItem('muro_token')).toBe('jwt-123')
    })

    // ── 3. Logout → state temizlenmeli ─────────────────────────────────────────
    it('should clear state on logout', async () => {
        mockLogin.mockResolvedValueOnce({
            token: 'jwt-123', refreshToken: '', expiresAt: '',
            user: {
                id: '1', firstName: 'A', lastName: 'U', email: 'a@t.com',
                phone: null, role: 'Admin', studentType: null, demoExpiresAt: null, lastLoginAt: null, groupNames: [],
                isActive: true, createdAt: '',
                tenants: [{ tenantId: 't1', tenantName: 'T', tenantCode: 't', role: 'Admin', status: 'Active' }]
            }
        })

        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )

        await waitFor(() => expect(screen.getByTestId('loading').textContent).toBe('ready'))

        await act(async () => { screen.getByTestId('login-btn').click() })
        expect(screen.getByTestId('token').textContent).toBe('jwt-123')

        await act(async () => { screen.getByTestId('logout-btn').click() })
        expect(screen.getByTestId('user').textContent).toBe('none')
        expect(screen.getByTestId('token').textContent).toBe('none')
        expect(localStorage.getItem('muro_token')).toBeNull()
    })

    // ── 4. Kayıtlı token varsa me() çağrılmalı ────────────────────────────────
    it('should call me() if token exists in localStorage', async () => {
        localStorage.setItem('muro_token', 'saved-token')
        mockMe.mockResolvedValueOnce({
            id: '1', firstName: 'B', lastName: 'U', email: 'b@t.com',
            phone: null, role: 'Admin', studentType: null, demoExpiresAt: null, lastLoginAt: null, groupNames: [],
            isActive: true, createdAt: '',
            tenants: [{ tenantId: 't2', tenantName: 'T2', tenantCode: 't2', role: 'Admin', status: 'Active' }]
        })

        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )

        await waitFor(() => {
            expect(screen.getByTestId('user').textContent).toBe('b@t.com')
        })

        expect(mockMe).toHaveBeenCalledWith('saved-token')
        expect(screen.getByTestId('tenant').textContent).toBe('t2')
    })

    // ── 5. me() hata verirse token temizlenmeli ────────────────────────────────
    it('should clear token if me() fails', async () => {
        localStorage.setItem('muro_token', 'expired-token')
        mockMe.mockRejectedValueOnce(new Error('Unauthorized'))

        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )

        await waitFor(() => {
            expect(screen.getByTestId('loading').textContent).toBe('ready')
        })

        expect(screen.getByTestId('user').textContent).toBe('none')
        expect(localStorage.getItem('muro_token')).toBeNull()
    })

    // ── 6. useAuth context dışında hata fırlatmalı ─────────────────────────────
    it('should throw error when used outside AuthProvider', () => {
        function Bad() {
            useAuth()
            return null
        }

        expect(() => render(<Bad />)).toThrow('useAuth must be used within AuthProvider')
    })

    // ── 7. session:kicked event → logout ───────────────────────────────────────
    it('should logout on session:kicked event', async () => {
        vi.spyOn(window, 'alert').mockImplementation(() => { })

        mockLogin.mockResolvedValueOnce({
            token: 'jwt-abc', refreshToken: '', expiresAt: '',
            user: {
                id: '1', firstName: 'C', lastName: 'U', email: 'c@t.com',
                phone: null, role: 'Admin', studentType: null, demoExpiresAt: null, lastLoginAt: null, groupNames: [],
                isActive: true, createdAt: '',
                tenants: [{ tenantId: 't3', tenantName: 'T', tenantCode: 't', role: 'Admin', status: 'Active' }]
            }
        })

        render(
            <AuthProvider><TestConsumer /></AuthProvider>
        )
        await waitFor(() => expect(screen.getByTestId('loading').textContent).toBe('ready'))

        await act(async () => { screen.getByTestId('login-btn').click() })
        expect(screen.getByTestId('token').textContent).toBe('jwt-abc')

        // Dispatch session:kicked
        await act(async () => {
            window.dispatchEvent(new CustomEvent('session:kicked', { detail: 'Başka cihaz' }))
        })

        expect(screen.getByTestId('user').textContent).toBe('none')
        expect(screen.getByTestId('token').textContent).toBe('none')
    })
})
