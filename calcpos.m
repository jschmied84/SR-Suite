function calcpos(number)

rest = mod(number,12);
ganz = floor(number/12);

if(rest == 0)
    ganz = ganz - 1;
    rest = 12;
end

switch ganz
    case 0
        row = 'A'
    case 1
        row = 'B'
    case 2
        row = 'C'
    case 3
        row = 'D'
    case 4
        row = 'E'
    case 5
        row = 'F'
    case 6
        row = 'G'
    case 7
        row = 'H'
end

rest



