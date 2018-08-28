'use strict';

module.exports = {
  extends: 'airbnb-base',
  parserOptions: {
    sourceType: 'script'
  },
  settings: {
    'import/core-modules': ['process']
  },
  env: {
    browser: false,
    node: true,
    es6: true,
    jest: true,
    jasmine: true
  },
  rules: {
    'arrow-body-style': 0,
    'class-methods-use-this': 0,
    'comma-dangle': [2, 'never'],
    'complexity': [2, 11],
    'import/no-extraneous-dependencies': [2, { devDependencies: true }],
    'max-statements': [2, 20],
    'no-plusplus': 0,
    'no-restricted-syntax': [
      2,
      {
        'selector': 'LabeledStatement',
        'message': 'Labels are a form of GOTO; using them makes code confusing and hard to maintain and understand.'
      },
      {
        'selector': 'WithStatement',
        'message': '`with` is disallowed in strict mode because it makes code impossible to predict and optimize.'
      }
    ],
    'no-use-before-define': [2, { functions: false }],
    'no-underscore-dangle': [2, { allowAfterThis: true }],
    'prefer-template': 0,
    'no-continue': 0,
    'no-await-in-loop': 0,
    'no-return-assign': 0,
    'no-useless-computed-key': 0,
    'no-console': 0
  }
};
