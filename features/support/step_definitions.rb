When(/^the generated files for "(.*?)" are removed$/) do |img|
  puts "!!!!!!!!!!!!!!!!"
  puts `pwd`
  ['small','medium','large'].each do |size|
    FileUtils.rm( File.join(current_dir,'images',img,"#{File.basename(img)}-#{size}.jpg") )
  end
end
