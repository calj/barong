require 'bump'

def bot_username
  ENV.fetch("BOT_USERNAME", "rubykube-bot")
end

def repository_slug
  ENV.fetch("REPOSITORY_SLUG", "rubykube/barong")
end

namespace 'release' do

  desc "Bump the version of the application"
  task :patch do
    if ENV["TRAVIS_PULL_REQUEST"] != "false"
      Kernel.abort "Bumping version aborted: GitHub pull request detected."
    end

    unless ENV["TRAVIS_TAG"].to_s.empty?
      Kernel.abort "Bumping version aborted: the build has been triggered by Git tag."
    end

    Bump::Bump.run("patch", commit_message: '[no ci] Release', tag: true)
    sh "git remote add authenticated-origin https://#{bot_username}:#{ENV.fetch("GITHUB_API_KEY")}@github.com/#{repository_slug}"
    sh "git push --tags authenticated-origin HEAD:#{ENV.fetch('TRAVIS_BRANCH')}"
  end
end
