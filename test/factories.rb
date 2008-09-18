Factory.sequence :tag do |n|
  "Tag #{n}"
end

Factory.define :post do |p|
  p.title 'This is a post title'
  p.body  'This is a body'
end

Factory.define :tag do |t|
  t.name { Factory.next(:tag) }
end