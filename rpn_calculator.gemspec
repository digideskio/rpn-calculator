Gem::Specification.new do |spec|
  spec.name                  = 'rpn_calculator'
  spec.version               = '0.0.1'
  spec.date                  = '2016-04-03'
  spec.summary               = 'A simple RPN calculator.'
  spec.authors               = ['Zach Jones']
  spec.email                 = 'zt.jones88@gmail.com'
  spec.files                 = `git ls-files`.split($/)
  spec.homepage              = 'http://zajn.tech'
  spec.executables           = 'rpn-calculator'
  spec.require_paths         = ['lib']
  spec.required_ruby_version = '~> 2.0'
  spec.license               = 'MIT'
end
