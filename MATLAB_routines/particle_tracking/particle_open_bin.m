clear

% ** This code imports the particle-tracking data directly from bin output
% files. 
% ** The file path has to be specified.
% ** output is a 3D matrix where the 1st dimension is the particle number,
% the 2nd dimension is the model time, and the 3rd diemnsion is the
% recorded variables.

%%%%%%%%%%%%%%%%%%%%%%%%
% WARNING
%%%%%%%%%%%%%%%%%%%%%%%%
% This routine SHOULD NOT BE USED FOR LARGE FILES otherwise MATLAB matrices
% will become too large and will crash MATLAB.
%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%

% number of files to import into matlab
number_of_files = 10;
% filepath
path = pwd;%'specify the path for the output files here';
% Number of variables recorded (see particles.f90)
number_of_variables = 20;

%%%%%%%%%%%%%%%%%%%%%%%%
% CORE CODE
%%%%%%%%%%%%%%%%%%%%%%%%
counter = 1;

% Loops through the nummber of files to open
for filenum = 1:number_of_files
    
    % Create fullpath
    filename = ['op.parti-',num2str(filenum,'%03.f'),'.bin'];
    fullpath = [path,'/',filename];
    
    % Display the file being extracted
    disp(filename);
    
    % Open the file
    fileID = fopen(fullpath);
    
    % Extract the data (refer to particles.f90 to confirm that number)
    A = fread(fileID,[number_of_variables Inf],'double');
    A = A';
    
    % Finds the number of particle per file using the ID numbers
    if filenum == 1
        partnum = max(A(:,1))-min(A(:,1))+1;
    end
    
    % write a matrix of dimensions:
    % # of particles x timestep x recorded variables
    for Np = (filenum-1)*partnum+1:(filenum-1)*partnum+partnum
        ind = find(A(:,1) == Np);
        data(counter,:,:) = A(ind(1:35),:);
        counter = counter +1;
    end; clear Np ind
    
    fclose(fileID);
    clear A fileID filename fullpath ans
    
end; clear filenum partnum
