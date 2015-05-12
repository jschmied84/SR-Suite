function [imspot] = carstensearch(im,thr)

[szx, szy] = size(im);
imspot = zeros(size(im));

brd = 5;


for i = brd:szx-brd
    
    for j = brd:szy-brd
        
        is = 0;
        os = 0;
        cv = 1;
    
        is = is + im(i,j);
        is = is + im(i-1,j);
        is = is + im(i-1,j-1);
        is = is + im(i-1,j+1);
        is = is + im(i,j+1); 
        is = is + im(i,j-1);
        is = is + im(i+1,j);
        is = is + im(i+1,j-1);
        is = is + im(i+1,j+1);
        
        cv = cv * im(i,j) * im(i-1,j) * im(i-1,j-1) * im(i-1,j+1) * im(i,j+1) * im(i,j-1) * im(i+1,j) * im(i+1,j-1) * im(i+1,j+1);
        
        is = is/9;
        
        os = os + im(i-3,j);
        os = os + im(i-3,j-1);
        os = os + im(i-3,j-2);
        os = os + im(i-3,j-3);
        os = os + im(i-3,j+1);
        os = os + im(i-3,j+2);
        os = os + im(i-3,j+3);
        
        cv = cv * im(i-3,j) * im(i-3,j-1) * im(i-3,j-2) * im(i-3,j-3) * im(i-3,j+1) * im(i-3,j+2) * im(i-3,j+3);
         
        os = os + im(i,j+3);
        os = os + im(i-1,j+3);
        os = os + im(i-2,j+3);
        os = os + im(i+1,j+3);
        os = os + im(i+2,j+3);
        
        cv = cv * im(i,j+3) * im(i-1,j+3) * im(i-2,j+3) * im(i+1,j+3) * im(i+2,j+3);
        
        os = os + im(i,j-3);
        os = os + im(i-1,j-3);
        os = os + im(i-2,j-3);
        os = os + im(i+1,j-3);
        os = os + im(i+2,j-3);
        
        cv = cv * im(i,j-3) * im(i-1,j-3) * im(i-2,j-3) * im(i+1,j-3) * im(i+2,j-3);
        
        os = os + im(i+3,j);
        os = os + im(i+3,j-1);
        os = os + im(i+3,j-2);
        os = os + im(i+3,j-3);
        os = os + im(i+3,j+1);
        os = os + im(i+3,j+2);
        os = os + im(i+3,j+3);
        
        cv = cv * im(i+3,j) * im(i+3,j-1) * im(i+3,j-2) * im(i+3,j-3) * im(i+3,j+1) * im(i+3,j+2) * im(i+3,j+3);
        
        os = os/24;
        
        if (is/os >= thr && cv > 0)
            imspot(i,j) = 1;
        end
    end
    
end

