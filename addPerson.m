function res = addPerson(fimage, image_type)%, name, fnames, fvec)
    % Read given image and convert to gray scale
    I = rgb2gray(imread(fimage, image_type));
    % Resize image so that it is a N by N matrix (N = 100)
    I = imresize(I,[100 100]);
    % Turn matrix of RGB values into a column vector
    Ivec = I(:);
    res = Ivec;
    % Now that we have processed the image and converted it into a
    % column vector we need to store it somewhere.
    % We will store the processed image in one csv file and the
    % respective name in another csv file.
    
%     fid = fopen(fnames, 'a');
%     fprintf(fid, '%s\n', name);
%     fclose(fid);
%     dlmwrite(fvec, Ivec', '-append');
end
