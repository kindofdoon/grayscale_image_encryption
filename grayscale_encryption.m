function grayscale_encryption

    clc
    clear
    
    % Ref: https://www.johndcook.com/blog/2009/08/24/algorithms-convert-color-grayscale/
    
    %% User inputs

    filename = 'flag_medium.jpg';
    
    cw = [1/3 1/3 1/3]; % color weights, must sum to 1
%     cw = [0.2125 0.7154 0.0721]; % color weights, must sum to 1; Ref: http://jscience.org/experimental/javadoc/org/jscience/computing/ai/vision/GreyscaleFilter.html
%     cw = [0.21 0.72 0.07];
%     cw = [0.5 0.419 0.081];
%     cw = [0.299 0.587 0.114];
%     cw = [0.212 0.701 0.087]; % Ref: https://en.wikipedia.org/wiki/Luma_(video)
%     cw = [0.21 0.07 0.72];
    
    %% 
    
    I = double(imread(filename))/256;
    t = mean(I(:)); % target grayscale color
    un = cw/norm(cw); % unit normal vector
    cw = cw/sum(cw); % components must sum to 1
    
    %% Create images
    
    % Create encrypted image
    I_e = zeros(size(I)); % image, encrypted
    for y = 1:size(I,1)
        for x = 1:size(I,2)
        
            cc = [I(y,x,1) I(y,x,2) I(y,x,3)]; % color, current
            D = (dot(cw,cc) - t) / norm(cw); % distance from color to constraint plane; Ref: http://mathworld.wolfram.com/Point-PlaneDistance.html
            I_e(y,x,:) = cc - D*un; % color, new
            
            pc = squeeze(I_e(y,x,:)); % pixel check
            
            if max(pc<0) || max(pc>1)
                warning('Pixel was projected outside of range')
            end
        
        end
    end
    
    % Simulate grayscale image
    I_g = zeros(size(I)); % image, encrypted
    for y = 1:size(I,1)
        for x = 1:size(I,2)
            
            I_g(y,x,1) = dot(squeeze(I_e(y,x,:)),cw);
            I_g(y,x,2) = I_g(y,x,1);
            I_g(y,x,3) = I_g(y,x,1);
        
        end
    end
    
    %% Show results
    
    figure(1)
    clf
    
    set(gcf,'color','white')
    subplot(3,1,1)
    image(I)
    axis tight
    axis equal
    title('Original')
    
    subplot(3,1,2)
    image(I_e)
    axis tight
    axis equal
    title('Encrypted')
    
    subplot(3,1,3)
    image(I_g)
    axis tight
    axis equal
    title('To grayscale')
    
    cws = ''; % color weight string
    for a = 1:length(cw)
        cws = [cws num2str(cw(a)) '_' ];
    end
    cws = cws(1:end-1);
    cws = strrep(cws,'.','-');
    
    imwrite(I_e,regexprep(filename,'[.]',['_encrypted_' cws '.']))
    
    %%
    
    figure(2)
    clf
    
    ci = round(size(I,2)/2); % cutting index
    
    I_c = [I(:,1:ci,:), I_e(:,ci+1:end,:)];
    
    set(gcf,'color','white')
    image(I_c)
    axis tight
    axis equal
    title('Original')
    
    imwrite(I_c,regexprep(filename,'[.]',['_comparison_' cws '.']))
    
    %% Supporting functions below

end