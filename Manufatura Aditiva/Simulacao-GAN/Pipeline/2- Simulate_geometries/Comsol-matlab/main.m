function [Es,model] = main(dimension)

    arrays_dir = 'C:\Users\lucas\OneDrive\Documentos\Dados_GAN\Arrays\p4\';
    young_dir = 'C:\Users\lucas\OneDrive\Documentos\Dados_GAN\young\';

    datadirs = dir(arrays_dir); 
    dircell = struct2cell(datadirs)';   
    filenames = dircell(:,1);

    Es = [];
    
    dtheta = 45;
    theta_max = 45;
    
    for fid = (874:1000)
        datafilename = strcat(arrays_dir,filenames{fid+2})
        f  = fopen(datafilename,'r');
        f_e = fopen(strcat(young_dir,filenames{fid+2}),'wt');
        array = get_array(f);
        fclose(f);

        
        for theta = 0:dtheta:theta_max
            disp(theta);
            E = 0;
            try
                if dimension==2
                    [model,E] = simulation_2d(array,theta);
                else
                    [model,E] = simulation_3d(array,theta);
                end
            catch
                try
                    disp(theta+1);
                    if dimension==2
                        [model,E] = simulation_2d(array,theta);
                    else
                        [model,E] = simulation_3d(array,theta);
                    end
                catch
                    try
                        disp(theta-1);
                    	if dimension==2
                            [model,E] = simulation_2d(array,theta);
                        else
                            [model,E] = simulation_3d(array,theta);
                        end
                    catch
                        approved(fid) = false;
                    end
                end
            end
            Es(fid,int8(theta/dtheta)+1) = E;
        end
        fprintf(f_e,'%d\n',Es(fid,:)');
        fclose(f_e);
    end
end