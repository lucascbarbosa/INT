function array = get_array(f)
    
    data = textscan(f,'%s');
    data = data{1};
    size = sqrt(length(data));
    array = zeros(size);
    row = [];

    for i = (1:size)
        for j = (1:size)
            array(i,j) = str2double(data{(i-1)*size+j});
        end
    end

    end