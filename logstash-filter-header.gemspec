Gem::Specification.new do |s|
  s.name          = 'logstash-filter-header'
  s.version       = '0.1.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Add Logstash event header line into events'
  s.description   = 'Add the content of header lines into each events'
  s.homepage      = 'https://github.com/Transrian/logstash-codec-header'
  s.authors       = ['Valentin Bourdier']
  s.email         = 'valentin.bourdier@mail.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency 'lru_redux', "~> 1.1.0"
  s.add_development_dependency 'logstash-devutils'
end
