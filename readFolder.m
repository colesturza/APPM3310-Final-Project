function [fimage, image_type] = readFolder(folderName)
%This function reads a given folder name string and looks at the file names inside
%it 
%fimage = array of image names ie. {example.jpeg}
%image_type = array of image types ie. {jpeg}
addpath(folderName);
contents = dir([folderName,'/*.JPG']);
fimage = {contents.name};
%fimage(1:2)=[];

for i = 1:length(fimage)
    temp = fimage{i};
    loc=find(temp == '.');
    image_type(i) = {temp(loc+1:end)};
end

end