namespace :styles do
  desc "Populate database with styles"
  task populate: :environment do
    layouts.each { |l| Layout.create(l) }
    themes.each { |t| Theme.create(t) }
  end
end

def layouts
  [
    {name: "Grid", icon: "th"},
    {name: "List", icon: "th-list"},
    {name: "Magazine", icon: "th-large"}
  ]
end

def themes
  [
    {name: "Default", stylesheet: "default"},
    {name: "Dark", stylesheet: "dark"}
  ]
end