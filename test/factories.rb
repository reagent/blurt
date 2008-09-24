Factory.sequence(:tag)  {|n| "Tag #{n}" }
Factory.sequence(:slug) {|n| "this-is-a-post-title-#{n}"}

Factory.define :post do |p|
  p.title 'This is a post title'
  p.body  'This is a body'
  p.slug  { Factory.next(:slug) }
end

Factory.define :tag do |t|
  t.name { Factory.next(:tag) }
end