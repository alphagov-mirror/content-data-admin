desc "Run govuk-lint on all files"
task lint: :environment do
  sh "bundle exec rubocop app config lib spec --parallel"
  sh "bundle exec scss-lint app/assets/stylesheets"
end
