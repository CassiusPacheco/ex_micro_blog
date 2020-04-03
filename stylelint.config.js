module.export = {
  rules: {
    'at-rule-unknown': [
      true,
      {
        ignoreAllRules: [
          'tailwind',
          'apply',
          'variant',
          'responsive',
          'screen'
        ]
      }
    ]
  }
}
