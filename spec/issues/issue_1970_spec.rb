require 'spec_helper'

describe 'issue #1970' do
  class User
    include Mongoid::Document

    field :name, type: String

    has_many :edited_posts, class_name: "Post", inverse_of: :editor
    has_many :posts
  end

  class Post
    include Mongoid::Document

    belongs_to :user
    belongs_to :editor, class_name: "User", inverse_of: :edited_posts

    before_save do
      ["editor", "user"].each do |field|
        #this line seems to trigger the issue
        self.send(field, true)
      end
    end
  end

  it 'should be well associate' do
    editor = User.create(name: "Editor")
    writer = User.create(name: "Writer")
    post = Post.create(editor: editor, user: writer)

    post.editor.name.should eq('Editor') #=> Writer, should be Editor
  end
end
