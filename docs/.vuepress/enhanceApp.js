import 'mermaid/dist/mermaid.min.css'

export default ({
  Vue,
  options,
  router,
  siteData
}) => {
  // 引入 mermaid
  if (typeof window !== 'undefined') {
    import('mermaid').then(mermaid => {
      mermaid.default.initialize({
        startOnLoad: true,
        theme: 'default'
      })
    })
  }
} 