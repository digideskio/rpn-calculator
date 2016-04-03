Gem::Specification.new do |s|
  s.name = 'rpn_calculator'
  s.version = '0.0.1'
  s.date = '2016-04-03'
  s.summary = 'A simple RPN calculator.'
  s.authors = ['Zach Jones']
  s.email   = 'zt.jones88@gmail.com'
  s.files   = `git ls-files`.split($/)
  s.executables = 'bin/rpn-calculator'
  s.require_paths = ['lib']
end
