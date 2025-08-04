module.exports = {
  title: '支付系统学习资源',
  description: '支付系统相关的技术文档、架构设计、最佳实践等学习资源',
  base: '/trading-system/',
  themeConfig: {
    nav: [
      { text: '首页', link: '/' },
      { text: '教程', link: '/tutorials/' },
      { text: '架构', link: '/architecture/' },
      { text: '最佳实践', link: '/best-practices/' },
      { text: 'GitHub', link: 'https://github.com/Findstarer/trading-system' }
    ],
    sidebar: {
      '/tutorials/': [
        {
          title: '基础教程',
          collapsable: false,
          children: [
            'payment-system-overview',
            'payment-flow',
            'payment-states'
          ]
        }
      ],
      '/architecture/': [
        {
          title: '系统架构',
          collapsable: false,
          children: [
            'system-architecture',
            'database-design',
            'api-design'
          ]
        }
      ],
      '/best-practices/': [
        {
          title: '最佳实践',
          collapsable: false,
          children: [
            'security',
            'performance',
            'monitoring'
          ]
        }
      ]
    }
  },
  plugins: [
    '@vuepress/back-to-top',
    '@vuepress/medium-zoom'
  ]
} 