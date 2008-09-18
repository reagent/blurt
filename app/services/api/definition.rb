module Api
  class Definition < ActionWebService::API::Base
    inflect_names false

    api_method :newPost, 
      :expects => [
        {:blogid   => :string}, 
        {:username => :string},
        {:password => :string},
        {:struct   => Api::Struct::Post},
        {:publish  => :int}
      ],
      :returns => [:string]

    api_method :getPost,
      :expects => [
        {:postid   => :string},
        {:username => :string},
        {:password => :string}
      ],
      :returns => [Api::Struct::Post]
      
    api_method :editPost,
      :expects => [
        {:postid   => :string},
        {:username => :string},
        {:password => :string},
        {:struct   => Api::Struct::Post}, 
        {:publish  => [:int]}
      ],
      :returns => [:bool]
      
    api_method :getRecentPosts,
      :expects => [
        {:blogid        => :string},
        {:username      => :string},
        {:password      => :string},
        {:numberOfPosts => :int}
      ],
      :returns => [[Api::Struct::Post]]

    api_method :getCategories,
      :expects => [
        {:blogid   => :string},
        {:username => :string},
        {:password => :string}
      ],
      :returns => [[Api::Struct::Tag]]

  end
end