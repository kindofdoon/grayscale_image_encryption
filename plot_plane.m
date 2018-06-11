% function plot_plane

clear
clc

    cw = [1/3 1/3 1/3]; % color weights, must sum to 1
%     cw = [0.2125 0.7154 0.0721]; % color weights, must sum to 1; Ref: http://jscience.org/experimental/javadoc/org/jscience/computing/ai/vision/GreyscaleFilter.html
%     cw = [0.21 0.72 0.07];
%     cw = [0.5 0.419 0.081];
%     cw = [0.299 0.587 0.114];
%     cw = [0.212 0.701 0.087]; % Ref: https://en.wikipedia.org/wiki/Luma_(video)
    
    
    t = 0.50;
    res = 20;
    t_range = linspace(0.2, 0.8, 3);
    
    figure(1)
    clf
    set(gcf,'color','white')
    
    cws = ''; % color weight string
    for a = 1:length(cw)
        cws = [cws num2str(round(cw(a)*100)/100) ', ' ];
    end
    cws = cws(1:end-2);
    
    for t_ind = 1:length(t_range)
        t = t_range(t_ind);
        subplot(length(t_range),1,t_ind)
        

        [X,Y] = meshgrid(linspace(0,1,res),linspace(0,1,res));
        Z = (t - cw(1)*X - cw(2)*Y)/cw(3);

        C(:,:,1) = X;
        C(:,:,2) = Y;
        C(:,:,3) = Z;

        surf(X,Y,Z,C,'EdgeColor','none')

        xlabel('Red')
        ylabel('Green')
        zlabel('Blue')
        if t_ind == 1
            title({
                    ['Weights: [' cws ']']
                    ['\rmK: ' num2str(t)]
                  })
        else
            title(['\rmK: ' num2str(t)])
        end
        

        axis([0 1 0 1 0 1])
        axis vis3d

        view([-45 20])
        set(gca,'FontSize',9)
    end
    
    set(gcf,'Position',[-1400 100 640 700])

% end