Given(/^the file "(.*?)" has been overwritten with "(.*?)"$/) do |file1,file2|
  FileUtils.cp File.join(expand_path('.'),file2), File.join(expand_path('.'),file1)
end

Given(/^some time has passed$/) do
  sleep 30
end

Then(/^we should write some stuff to the console$/) do
  puts "here's index.html"
  puts File.open(File.join(expand_path('.'),"index.html")).read
  puts "------"
  puts File.open(File.join(expand_path('.'),"photos/test-image/test-image-small.jpg"),'rb').read
end
