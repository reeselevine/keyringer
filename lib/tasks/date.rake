require "pp"
namespace :data do
  desc "import data from files to database"
  task :import => :environment do
    file = File.open(File.join(Rails.root, "lib", "tasks", "products.txt"), "r")
    file.each_with_index  do |line,index|
      if index == 0
        next
      end
      attrs = line.split("#")
      p = Product.find_or_initialize_by_name(attrs[0])
      p.name = attrs[0]
      p.price = attrs[1].to_f
      p.image_path = attrs[2]
      p.description = attrs[3]
      p.save!
    end
  end
end