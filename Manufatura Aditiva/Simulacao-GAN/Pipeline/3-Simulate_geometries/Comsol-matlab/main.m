function [Es,model,approved] = main(iso_cutoff)

    arrays_dir = 'C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Simulacao-GAN\Dados\1- Arranged_geometries\Arrays\';
    young_dir = 'C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Simulacao-GAN\Dados\3- Mechanical_properties\E\';

    datadirs = dir(arrays_dir); 
    dircell = struct2cell(datadirs)' ;   
    filenames = dircell(:,1);

    Es = [];
    approved = [];
    
    dtheta = 5;
    theta_max = 45;
    
    for fid = (1:1)
        datafilename =strcat(arrays_dir,filenames{fid+2}); 
        f  = fopen(datafilename,'r');
        data = textscan(f,'%s');
        data = data{1};
        size = sqrt(length(data));
        fclose(f);
        array = zeros(size);
        row = [];

        for i = (1:size)
            for j = (1:size)
                array(i,j) = str2double(data{(i-1)*size+j});
            end
        end
        
        for theta = 0:dtheta:theta_max
            disp(theta);
            E = 0;
            try
                [model,E] = simulation(array,theta);
            catch
                try
                    disp(theta+1);
                    [model,E] = simulation(array,theta);
                catch
                    try
                        disp(theta-1);
                    	[model,E] = simulation(array,theta-1);
                    catch
                        approved(fid) = false;
                    end
                end
            end
            Es(int8(theta/dtheta)+1) = E;
        end
        disp(Es);
        m = min(Es);
        M = max(Es);
        iso = (M-m)/(M+m);
        if iso <= iso_cutoff
            approved(fid) = true;
        else
            approved(fid) = false;
        end
    end
end