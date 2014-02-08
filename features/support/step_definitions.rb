Given(/^the file "(.*?)" has been overwritten with "(.*?)"$/) do |file1,file2|
  FileUtils.cp File.join(current_dir,file2), File.join(current_dir,file1)
end

Given(/^some time has passed$/) do
  sleep 30
end

Then(/^we should write some stuff to the console$/) do
  puts "here's index.html"
  puts File.open(File.join(current_dir,"index.html")).read
  puts "------"
  puts File.open(File.join(current_dir,"photos/test-image/test-image-small.jpg"),'rb').read
end
