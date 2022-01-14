function Es = main(dimension,start_geometry,end_geometry)

    arrays_dir = 'E:\Lucas GAN\Dados\1- Arranged_geometries\Arrays\RTGA\p4\';
    young_dir = 'E:\Lucas GAN\Dados\3- Mechanical_properties\young_COMSOL\';

    datadirs = dir(arrays_dir); 
    dircell = struct2cell(datadirs)';   
    filenames = dircell(:,1);

    Es = [];
    
    dtheta = 45;
    theta_max = 45;
    
    for fid = (start_geometry:end_geometry)
        datafilename = strcat(arrays_dir,filenames{fid+2});
        f  = fopen(datafilename,'r');
        file_out = fopen(strcat(young_dir,filenames{fid+2}),'wt');
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
        fprintf(file_out,'%d\n',Es(fid,:)');
        fclose(file_out);
    end
end