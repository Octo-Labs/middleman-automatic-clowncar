Given(/^the file "(.*?)" has been overwritten with "(.*?)"$/) do |file1,file2|
  FileUtils.cp File.join(current_dir,file2), File.join(current_dir,file1)
end

Given(/^some time has passed$/) do
  sleep 30
end
