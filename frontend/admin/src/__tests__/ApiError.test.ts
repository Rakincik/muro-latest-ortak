import { describe, it, expect } from 'vitest'
import { ApiError } from '@/lib/api'

describe('ApiError', () => {
    it('should have correct statusCode and message', () => {
        const err = new ApiError('Not Found', 404)
        expect(err.message).toBe('Not Found')
        expect(err.statusCode).toBe(404)
        expect(err.name).toBe('ApiError')
        expect(err).toBeInstanceOf(Error)
    })

    it('should work with different status codes', () => {
        const cases = [
            { msg: 'Unauthorized', code: 401 },
            { msg: 'Forbidden', code: 403 },
            { msg: 'Server Error', code: 500 },
            { msg: 'Rate Limited', code: 429 },
        ]

        cases.forEach(({ msg, code }) => {
            const err = new ApiError(msg, code)
            expect(err.statusCode).toBe(code)
            expect(err.message).toBe(msg)
        })
    })
})
