# -*- encoding: utf-8 -*-
# stub: git-version-bump 0.15.1 ruby lib

Gem::Specification.new do |s|
  s.name = "git-version-bump".freeze
  s.version = "0.15.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matt Palmer".freeze]
  s.date = "2015-07-01"
  s.executables = ["git-version-bump".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "bin/git-version-bump".freeze]
  s.homepage = "http://theshed.hezmatt.org/git-version-bump".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.rubygems_version = "2.6.6".freeze
  s.summary = "Manage your app version entirely via git tags".freeze

  s.installed_by_version = "2.6.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<github-release>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
    else
      s.add_dependency(%q<github-release>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<github-release>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
  end
end
