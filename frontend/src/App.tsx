import { useEffect, useState } from 'react'

type Status = 'checking' | 'ready' | 'unavailable'

export default function App() {
  const [status, setStatus] = useState<Status>('checking')

  useEffect(() => {
    const controller = new AbortController()
    const timeout = window.setTimeout(() => controller.abort(), 10_000)
    let active = true

    async function checkBackend() {
      try {
        const response = await fetch('/api/health', { signal: controller.signal })
        if (!response.ok) throw new Error('Backend unavailable')
        const body: unknown = await response.json()
        if (active) {
          setStatus(
            typeof body === 'object' && body !== null && 'status' in body && body.status === 'UP'
              ? 'ready' : 'unavailable',
          )
        }
      } catch {
        if (active) setStatus('unavailable')
      } finally {
        window.clearTimeout(timeout)
      }
    }

    void checkBackend()
    return () => {
      active = false
      window.clearTimeout(timeout)
      controller.abort()
    }
  }, [])

  return (
    <main>
      <p className="eyebrow">IAM PLATFORM · ENGINEERING FOUNDATION</p>
      <h1>Identity & access portal</h1>
      <p>The foundation is ready for the Phase 1 portal pilot.</p>
      <p role="status" className={`status ${status}`}>
        {status === 'checking' && 'Checking backend connection…'}
        {status === 'ready' && 'Backend connected'}
        {status === 'unavailable' && 'Backend unavailable. Check the service and try again.'}
      </p>
      <p>Access requests, approvals, and sign-in will be added in later milestones.</p>
    </main>
  )
}
