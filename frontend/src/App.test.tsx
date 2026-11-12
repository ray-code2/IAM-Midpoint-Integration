import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import App from './App'

describe('portal backend status', () => {
  it('shows connected only after the backend reports UP', async () => {
    const fetchMock = vi.fn().mockResolvedValue(new Response(JSON.stringify({ status: 'UP' })))
    vi.stubGlobal('fetch', fetchMock)
    render(<App />)
    expect(screen.getByRole('status')).toHaveTextContent('Checking backend')
    expect(await screen.findByText('Backend connected')).toBeInTheDocument()
    expect(fetchMock).toHaveBeenCalledWith('/api/health', expect.objectContaining({ signal: expect.any(AbortSignal) }))
  })

  it.each([
    new Response(JSON.stringify({ status: 'DOWN' })),
    new Response('service unavailable', { status: 503 }),
    new Response('not json'),
  ])('does not report success for unhealthy or invalid responses', async (response) => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue(response))
    render(<App />)
    expect(await screen.findByText(/Backend unavailable/)).toBeInTheDocument()
  })

  it('handles a network error', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('Network error')))
    render(<App />)
    expect(await screen.findByText(/Backend unavailable/)).toBeInTheDocument()
  })
})
