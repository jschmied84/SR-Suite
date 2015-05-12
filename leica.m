function varargout = leica(varargin)
% LEICA MATLAB code for leica.fig
%      LEICA, by itself, creates a new LEICA or raises the existing
%      singleton*.
%
%      H = LEICA returns the handle to a new LEICA or the handle to
%      the existing singleton*.
%
%      LEICA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEICA.M with the given input arguments.
%
%      LEICA('Property','Value',...) creates a new LEICA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before leica_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to leica_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help leica

% Last Modified by GUIDE v2.5 07-Mar-2013 21:10:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @leica_OpeningFcn, ...
    'gui_OutputFcn',  @leica_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before leica is made visible.
function leica_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to leica (see VARARGIN)

% Choose default command line output for leica
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes leica wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = leica_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im im2 indim name pxs

pxs = str2num(get(handles.edit2,'String'));

indim = 1;
impath = get(handles.edit1,'String');
cd(impath);
out = uipickfiles;
name = out{1}

im = imread(name);
im2 = imread(name);

%  sm = fspecial('gauss', 2, 2);
%  im = filter2(sm,im);
%  im2 = filter2(sm,im2);

axes(handles.axes1);
imshow(im,[min(min(im)),0.7*max(max(im))]);

% [x1,y2] = (ginput(1));
% [x2,y1] = (ginput(1));
% x1 = round(x1);
% x2 = round(x2);
% y1 = round(y1);
% y2 = round(y2);
% imroib = double(im(y1:y2, x1:x2));
%
% backg = mean(mean(imroib))
%
% im = im - backg - 3*std(backg);

% axes(handles.axes1);
% imshow(im,[min(min(im)),max(max(im))]);
% colormap('hot');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im imroi im2 imroi2

axes(handles.axes1);
[x1,y2] = (ginput(1));
[x2,y1] = (ginput(1));
x1 = round(x1);
x2 = round(x2);
y1 = round(y1);
y2 = round(y2);
imroi = double(im(y1:y2, x1:x2));
imroi2 = double(im2(y1:y2, x1:x2));

imroirs = imresize(imroi,10,'nearest');

figure(1)
imshow(imroirs,[min(min(imroirs)),max(max(imroirs))]);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im name

axes(handles.axes1);
imshow(im,[min(min(im)),0.8*max(max(im))]);
colormap('hot');

maxv = 0.8*max(max(im));

savename = [name,'SR-im.png'];
im = (im./maxv);
im = (round(255*im));
imwrite(im,hot(255),savename);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global imroi rimroi factor imroi2 rimroi2

factor = 10;

rotangle = -get(handles.slider1,'Value')

rimroi = imrotate(imroi,rotangle,'bilinear','loose');
rimroi2 = imrotate(imroi2,rotangle,'bilinear','loose');

imroirs = imresize(rimroi,factor,'nearest');
imroirs2 = imresize(rimroi2,factor,'nearest');

figure(1)
imshow(imroirs,[min(min(imroirs)),max(max(imroirs))]);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global rimroi factor colx col dist rimroi2 pxs


clear global col colx

figure(1);
[x1,y2] = (ginput(1));
[x2,y1] = (ginput(1));
x1 = round(x1/factor);
x2 = round(x2/factor);
y1 = round(y1/factor);
y2 = round(y2/factor);
rimroi = double(rimroi(y1:y2, x1:x2));
rimroi2 = double(rimroi2(y1:y2, x1:x2));

imroirs = imresize(rimroi,factor,'nearest');


figure(1)
imshow(imroirs,[min(min(imroirs)),max(max(imroirs))]);

[szy,szx] = size(rimroi);

for i=1:szx
    col(i) = mean(rimroi(:,i));
    colx(i) = i;
end

figure(2);
clf
plot(colx,col);

[A1,xc1,w1,A2,xc2,w2] = doublegauss(colx,col)

dist = pxs*abs(xc2-xc1)

set(handles.text1,'String',num2str(dist));


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global dist rimroi2 indim
global a1 st1 a2 st2 name

resdata = fopen('distances.txt','a');
fprintf(resdata,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \n', dist, a1, a2, st1, st2);
fclose(resdata);

indim

str1 = num2str(indim);
str2 = '.png';
nameim = [name, str1, str2]
indim = indim + 1;

rimroi2 = rimroi2/(max(max(rimroi2)));
rimroi2 = 255*rimroi2;

imwrite(uint8(round(rimroi2)),nameim,'png');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pxs

out = uipickfiles;

res = fopen('result.txt','a');
res2 = fopen('result2.txt','a');

orinumb = 1;

for t=1:length(out)
    
    name = out{t};
    
    im = imread(name);
    
    
    axes(handles.axes1);
    imshow(im,[min(min(im)),max(max(im))]);
    
    [imweich] = convol(im,10);
    
    axes(handles.axes1);
    imshow(imweich,[min(min(imweich)),max(max(imweich))]);
    colormap('hot');
    
    rsf = 0.15;
    imrs = imresize(imweich,rsf);
    
    figure(1)
    imshow(imrs,[min(min(imrs)),max(max(imrs))]);
    colormap('hot');
    
    [ x,y ] = singleimspot( imrs );
    
    
    
    figure(1)
    hold on;
    plot(x,y,'*','color','green');
    
    x = x/rsf;
    y = y/rsf;
    
    axes(handles.axes1);
    hold on;
    plot(x,y,'*','color','green');
    
    rois = 15;
    
    ind = 1;
    
    imsz = 995;
    
    for i=1:length(x)
        
        xzent = round(x(i));
        yzent = round(y(i));
        
        
        b = imsz;
        
        
        
        if((xzent > 2*rois) && (xzent < b ) && (yzent > 2*rois) && (yzent < b))
            
            
            imroi = imweich(yzent-rois:yzent+rois, xzent-rois:xzent+rois);
            
            figure(2)
            imshow(imroi,[min(min(imroi)),max(max(imroi))]);
            colormap('hot');
            
            [cx,cy,sx,sy,PeakOD, error] = Gaussian2D(imroi,0.00001);
            xn(ind) = cx + xzent - rois;
            yn(ind) = cy + yzent - rois;
            ind = ind + 1;
            
        end
        
    end
    
    axes(handles.axes1);
    imshow(im,[min(min(im)),max(max(im))]);
    hold on;
    plot(xn,yn,'*','color','green');
    
    rois = 10;
    
    ind = 1;
    
    for i=1:length(xn)
        
        xzent = round(xn(i));
        yzent = round(yn(i));
        
        
        b = imsz;
        
        
        
        if((xzent > rois) && (xzent < b ) && (yzent > rois) && (yzent < b))
            
            
            imroi = im(yzent-rois:yzent+rois, xzent-rois:xzent+rois);
            
            figure(2)
            imshow(imroi,[min(min(imroi)),max(max(imroi))]);
            colormap('hot');
            
            
            if(mean(mean(imroi)) > 20)
                xnn(ind) = xn(i);
                ynn(ind) = yn(i);
                ind = ind + 1;
            end
            
        end
        
    end
    
    axes(handles.axes1);
    imshow(im,[min(min(im)),max(max(im))]);
    hold on;
    plot(xnn,ynn,'*','color','green');
    
    rois = 7; %muss ungerade sein;
    
    
    
    
    for u=1:length(xnn)
        
        xzent = round(xnn(u));
        yzent = round(ynn(u));
        
        
        b = imsz;
        
        
        
        if((xzent > rois) && (xzent < b ) && (yzent > rois) && (yzent < b))
            
            
            imroi = im(yzent-rois:yzent+rois, xzent-rois:xzent+rois);
            bigimroi = im(yzent-2*rois:yzent+2*rois, xzent-2*rois:xzent+2*rois);
            
            
            inw = 1;
            
            figure(10)
            clf
            
            red = 0;
            blue = 0;
            
            for w=5:5:185
                
                
                
                rimroi = imrotate(imroi,w,'nearest','crop');
                
                rrimroi = imresize(rimroi,6,'nearest');
                
                [szy,szx] = size(rimroi);
                
                for i=1:szx
                    col(i) = mean(rimroi(:,i));
                    colx(i) = i;
                end
                
                
                
                figure(10);
                h2 = subplot(2,2,1);
                cla(h2)
                plot(colx,col);
                drawnow;
                
                in1 = 1;
                in2 = 1;
                
                bx = rois+1;
                for i=1:length(col)
                    
                    if(colx(i) <= bx)
                        x1(in1) = colx(i);
                        y1(in1) = col(i);
                        in1 = in1 + 1;
                    end
                    
                    if(colx(i) > bx)
                        x2(in2) = colx(i);
                        y2(in2) = col(i);
                        in2 = in2 + 1;
                    end
                    
                end
                
                
                
                figure(3)
                plot(x1,y1)
                f1 = ezfit('gauss');
                figure(3);
                showfit(f1);
                mu1 = f1.m(3);
                aa1 = f1.m(1);
                std1 = f1.m(2);
                r1 = f1.r;
                
                figure(4)
                plot(x2,y2);
                f2 = ezfit('gauss');
                figure(4);
                showfit(f2);
                mu2 = f2.m(3);
                aa2 = f2.m(1);
                std2 = f2.m(2);
                r2 = f2.r;
                
                
                
                
                figure(3)
                clf
                
                figure(4)
                clf
                
                
                
                xv = min(x1):0.01:max(x2);
                ydata1f = aa1*exp(-(xv-mu1).^2/(2*std1^2));
                ydata2f = aa2*exp(-(xv-mu2).^2/(2*std2^2));
                
                
                dist(w) = pxs*abs(mu2-mu1)
                
                
                
                if(mu1 > 0 && mu1 < 9 && mu2 > 9 && mu2 < 15 && mu1 < mu2)
                    
                    dist2(inw) = dist(w);
                    dist2wink(inw) = w;
                    inw = inw + 1;
                    
                    figure(10)
                    subplot(2,2,4);
                    hold on;
                    plot(w,dist(w),'.');
                    blue = blue + 1;
                    
                else
                    
                    figure(10)
                    subplot(2,2,4);
                    hold on;
                    plot(w,dist(w),'.','color','red');
                    red = red + 1;
                    
                end
                
                fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f\n', i,w,dist(w),mu1,mu2,r1,r2,std1,std2);
                
                figure(10)
                h4 = subplot(2,2,2)
                cla(h4);
                plot(colx,col);
                hold on;
                plot(xv,ydata1f,'color','red','LineWidth',3)
                hold on;
                plot(xv,ydata2f,'color','green','LineWidth',3);
                
                
                figure(10)
                subplot(2,2,3)
                imshow(rrimroi,[min(min(rrimroi)),max(max(rrimroi))]);
                colormap('hot');
                drawnow;
                
                
            end
            
            
            
        end
        
        if(inw > 1 && blue > 10)
            
            [maxdist,maxdistin] = max(dist2);
            winkel = dist2wink(maxdistin);
            fprintf(res2,'%6.5f \t %6.5f\n',u, maxdist);
            rimroi = imrotate(bigimroi,winkel,'nearest','crop');
            rrimroi = imresize(rimroi,6,'nearest');
            rrimroi = double(rrimroi);
            rrimroi = rrimroi./max(max(rrimroi));
            rrimroi = 65536*rrimroi;
            
            str1 = ('images\');
            str2 = num2str(orinumb,'%09d');
            str3 = ('.png');
            name = [str1,str2,str3];
            
            imwrite(uint16(round(rrimroi)),name,'png');
            
            orinumb = orinumb + 1;
        end
        
        clear dist2
        
    end
    
end


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(text1, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
