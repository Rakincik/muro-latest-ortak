import { describe, it, expect, vi, beforeEach } from 'vitest'
import { api, ApiError } from '@/lib/api'

describe('api() — base fetch wrapper', () => {
    const mockFetch = vi.mocked(global.fetch)

    beforeEach(() => {
        mockFetch.mockReset()
    })

    // ── 1. Başarılı JSON response ─────────────────────────────────────────────
    it('should return parsed JSON on 200', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(JSON.stringify({ id: 1, name: 'Test' }), {
                status: 200,
                headers: { 'Content-Type': 'application/json' },
            })
        )

        const result = await api<{ id: number; name: string }>('/test')

        expect(result).toEqual({ id: 1, name: 'Test' })
        expect(mockFetch).toHaveBeenCalledTimes(1)
    })

    // ── 2. 204 No Content → undefined ─────────────────────────────────────────
    it('should return undefined on 204', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(null, { status: 204 })
        )

        const result = await api('/test')

        expect(result).toBeUndefined()
    })

    // ── 3. Authorization header eklenmeli ──────────────────────────────────────
    it('should add Authorization header when token provided', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(JSON.stringify({}), { status: 200 })
        )

        await api('/test', { token: 'my-jwt-token' })

        const call = mockFetch.mock.calls[0]
        const headers = call[1]?.headers as Record<string, string>
        expect(headers['Authorization']).toBe('Bearer my-jwt-token')
    })

    // ── 4. X-Tenant-Id header eklenmeli ────────────────────────────────────────
    it('should add X-Tenant-Id header when tenantId provided', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(JSON.stringify({}), { status: 200 })
        )

        await api('/test', { tenantId: 'tenant-123' })

        const call = mockFetch.mock.calls[0]
        const headers = call[1]?.headers as Record<string, string>
        expect(headers['X-Tenant-Id']).toBe('tenant-123')
    })

    // ── 5. HTTP hata → ApiError fırlatmalı ─────────────────────────────────────
    it('should throw ApiError on non-OK response', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(JSON.stringify({ error: 'Not Found' }), { status: 404 })
        )

        await expect(api('/test')).rejects.toThrow(ApiError)
        await mockFetch.mockResolvedValueOnce(
            new Response(JSON.stringify({ error: 'Not Found' }), { status: 404 })
        )

        try {
            await api('/bad')
        } catch (err) {
            expect(err).toBeInstanceOf(ApiError)
            expect((err as ApiError).statusCode).toBe(404)
        }
    })

    // ── 6. SESSION_KICKED → window event ───────────────────────────────────────
    it('should dispatch session:kicked event on 401 SESSION_KICKED', async () => {
        const handler = vi.fn()
        window.addEventListener('session:kicked', handler)

        mockFetch.mockResolvedValueOnce(
            new Response(
                JSON.stringify({ error: 'SESSION_KICKED', message: 'Başka cihaz' }),
                { status: 401 }
            )
        )

        await expect(api('/test')).rejects.toThrow(ApiError)
        expect(handler).toHaveBeenCalledTimes(1)

        window.removeEventListener('session:kicked', handler)
    })

    // ── 7. Network hatası → TypeError ──────────────────────────────────────────
    it('should propagate network errors', async () => {
        mockFetch.mockRejectedValueOnce(new TypeError('Failed to fetch'))

        await expect(api('/test')).rejects.toThrow('Failed to fetch')
    })

    // ── 8. Validation errors → mesaj birleştirme ──────────────────────────────
    it('should combine validation error messages', async () => {
        mockFetch.mockResolvedValueOnce(
            new Response(
                JSON.stringify({ errors: { email: ['Required'], name: ['Too short'] } }),
                { status: 400 }
            )
        )

        try {
            await api('/test')
        } catch (err) {
            expect((err as ApiError).message).toContain('Required')
            expect((err as ApiError).message).toContain('Too short')
        }
    })
})
