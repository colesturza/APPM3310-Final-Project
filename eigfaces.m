clear;
close all;
clc;
global numEig;
numEig = 1000;
[imageNames,imageTypes] = readFolder('plain'); %Import all images.
numImages = length(imageNames); %Number of images.
faceMat = zeros(10000,numImages); %Matrix of faces.

for i = 1:numImages(1) %For all images call addPerson.m
    faceMat(:,i) = addPerson(imageNames{i},imageTypes{i});
end

%Pass face matrix to function to normalize;
[faceMatNorm,avg] = separate(faceMat);

%Pass normalized face matrix to eigStuff to calculate SVD and projections.
[U,sigma,projections] = eigStuff(faceMatNorm);
% %% Plot Singular Values for 1 Data Set instead of all
%  figure(4)
% sigvals = diag(sigma)/max(diag(sigma));
% l = length(sigvals);
% e85 = sigvals(accuracy(.85,sigma));
% e90 = sigvals(accuracy(.90,sigma));
% e95 = sigvals(accuracy(.91,sigma));
% plot(sigvals,'*','linewidth',2)
% hold on
% plot([0,l],[e85,e85],'--','linewidth',2)
% plot([0,l],[e90,e90],'--','linewidth',2)
% plot([0,l],[e95,e95],'--','linewidth',2)
% grid on
% xlabel('n')
% ylabel('nth Normalized Singular Value')
% title('Singular Values for Set of 27 Face Images')
% axis([0 l 0 max(sigvals)])
% legend('Singular Value','85% Convergence','90% Convergence','91% Convergence')

%%
%Training photos analyzed and ready for facial recognition.

[smiles,smileTypes] = readFolder('smile'); %Import smile photos to test.
numSmiles = length(smiles); %Number of images.
smileMat = zeros(10000,numSmiles); %Matrix of faces.

for i = 1:numSmiles(1) %For all images call addPerson.m
    smileMat(:,i) = addPerson(smiles{i},smileTypes{i});
end

for i=1:numSmiles(1)
    smileMat(:,i) = smileMat(:,i) - avg;
end
[smileMatNorm,avgsmile] = separate(smileMat);
%% Tilt Photos
[tilt,tiltTypes] = readFolder('tilt'); %Import smile photos to test.
numTilt = length(tilt); %Number of images.
tiltMat = zeros(10000,numTilt); %Matrix of faces.

for i = 1:numSmiles(1) %For all images call addPerson.m
    tiltMat(:,i) = addPerson(tilt{i},tiltTypes{i});
end

for i=1:numSmiles(1)
    tiltMat(:,i) = tiltMat(:,i) - avg;
end
[tiltMatNorm,avgtilt] = separate(tiltMat);

%% Combined Folders
% fullMatNorm = [faceMatNorm,smileMatNorm,tiltMatNorm];
% [Ufull,sigmafull,projectionsfull] = eigStuff(fullMatNorm);
% %plot(diag(sigmafull),'*')
% sigvals = diag(sigmafull)/max(diag(sigmafull));
% l = length(sigvals);
% e9 = sigvals(accuracy(.9,sigmafull));
% e99 = sigvals(accuracy(.95,sigmafull));
% e999 = sigvals(accuracy(.99,sigmafull));
% figure
% plot(sigvals,'*','linewidth',2)
% hold on
% plot([0,l],[e9,e9],'--','linewidth',2)
% plot([0,l],[e99,e99],'--','linewidth',2)
% plot([0,l],[e999,e999],'--','linewidth',2)
% grid on
% xlabel('n')
% ylabel('nth Normalized Singular Value')
% title('Singular Values for Set of 81 Face Images')
% axis([0 l 0 max(sigvals)])
% legend('Singular Value','90% Convergence','95% Convergence','99% Convergence')
%%
% figure
correct = 0;
for j = 1 : 27
chosenimage = j;
fprintf('Chosen Image: %.2f\n',chosenimage);
y = projector(U,tiltMat(:,chosenimage));

E_r = zeros(numSmiles(1),1);
for i=1:numSmiles(1)
   E_r(i,1) = norm(y-projections(:,i));
end

[value,index] = min(E_r);
error = 100*(mean(E_r) - value)/mean(E_r);
fprintf('Output Image: %.2f\n',index)
fprintf('Cerntainty: %.2f\n',error)
if index ~= chosenimage
    fprintf('Failed: %.2f\n',chosenimage)
end

if chosenimage >= 6 && chosenimage <= 9 
  subplot(2,2,j-5)
  bar(E_r/norm(E_r))
  %set(gca,'XTick',[], 'YTick', [])
  title(['"Tilted Face" Subject ',num2str(chosenimage)])
   xlabel('"Plain Face" Subject Number')
   ylabel('Error')
   %title(['Error from Training set Projection to Smiling Face of Subject ',num2str(chosenimage) ])
end
end

fprintf('Yah!\n');
% %% Subject Not in Database
% %remove subject from training set
% remsubj = 27;
% faceMatrem = faceMat(:,[1:remsubj-1,remsubj+1:end]);
% 
% %Pass face matrix to function to normalize;
% [faceMatNormrem,avgrem] = separate(faceMatrem);
% 
% %Pass normalized face matrix to eigStuff to calculate SVD and projections.
% [Urem,sigmarem,projectionsrem] = eigStuff(faceMatNormrem);
% fprintf('Chosen Image Not in Set: %.2f\n',remsubj);
% yrem = projector(Urem,smileMat(:,remsubj));
% 
% E_r = zeros(numSmiles(1),1);
% for i=1:numSmiles(1)
%    E_r(i,1) = norm(yrem-projections(:,i));
% end
% 
% [value,index] = min(E_r);
% error = 100*(mean(E_r) - value)/mean(E_r);
% fprintf('Output Image: %.2f\n',index)
% fprintf('Cerntainty: %.2f\n',error)
% 
% % figure
% % bar(E_r/norm(E_r))
% % %set(gca,'XTick',[], 'YTick', [])
% % title(['"Smiling Face" Subject ',num2str(remsubj)])
% %  xlabel('"Plain Face" Subject Not in Set')
% %  ylabel('Error')
% %  
% % %% Save Plots
% % saveas(1,'sigvals.png')
% % saveas(2,'accuracy.png')
% % % saveas(3,'removed.png')
