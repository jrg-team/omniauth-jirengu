# OmniAuth Jirengu


## Basic Usage

    use OmniAuth::Builder do
      provider :github, ENV['JIRENGU_KEY'], ENV['JIRENGU_SECRET']
    end


## Scopes

GitHub API v3 lets you set scopes to provide granular access to different types of data: 

	use OmniAuth::Builder do
      provider :github, ENV['JIRENGU_KEY'], ENV['JIRENGU_SECRET'], scope: "public,private"
    end

