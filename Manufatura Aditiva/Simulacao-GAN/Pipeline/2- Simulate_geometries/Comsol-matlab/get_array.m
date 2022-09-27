function array = get_array(simmetry, idx)
    
    arrays_dir = strcat('E:\Lucas GAN\Dados\1- Arranged_geometries\RTGA\',simmetry,'\');

    datadirs = dir(arrays_dir);
    dircell = struct2cell(datadirs)';   
    filenames = dircell(:,1);

    filename = filenames{idx};
    f  = fopen(strcat(arrays_dir,filename),'r');
    data = textscan(f,'%s');
    data = data{1};
    size = sqrt(length(data)-1);
    array = zeros(size);
    row = [];

    for i = (1:size)
        for j = (1:size)
            array(i,j) = str2double(data{(i-1)*size+j+1});
        end
    end

    end