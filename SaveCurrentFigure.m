function [] = SaveCurrentFigure(modelType, simType)

    % makes directory for today
    if ~exist('Figures', 'dir')
       mkdir('Figures');
    end
    figLocation = ['Figures/', datestr(now, 'mm-dd-yy')];
    if ~exist(figLocation, 'dir')
       mkdir(figLocation);
    end

    % saves figure(s)
    figFileName = [figLocation, '/', modelType, '_', simType, '_', ...
        datestr(now, 'HH:MM')];
    savefig(gcf, figFileName);
end

