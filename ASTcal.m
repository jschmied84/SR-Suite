function varargout = ASTcal(varargin)
% ASTCAL MATLAB code for ASTcal.fig
%      ASTCAL, by itself, creates a new ASTCAL or raises the existing
%      singleton*.
%
%      H = ASTCAL returns the handle to a new ASTCAL or the handle to
%      the existing singleton*.
%
%      ASTCAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASTCAL.M with the given input arguments.
%
%      ASTCAL('Property','Value',...) creates a new ASTCAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ASTcal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ASTcal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ASTcal

% Last Modified by GUIDE v2.5 26-Feb-2013 17:13:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ASTcal_OpeningFcn, ...
                   'gui_OutputFcn',  @ASTcal_OutputFcn, ...
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


% --- Executes just before ASTcal is made visible.
function ASTcal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ASTcal (see VARARGIN)

% Choose default command line output for ASTcal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ASTcal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ASTcal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% get curves
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning off;

global xval yval nsigx nsigy foldername

fmt_s = imformats('tif');
stfr = str2num(get(handles.edit1,'String'));
foldername = get(handles.edit5,'String');
cd(foldername)
out = uipickfiles;
directo = out{1};
cd(directo);
files = dir('*.tif');
nof = length(files);
filename = files(round(nof/2)).name;
I=double(myimread(filename,fmt_s));

clf(figure(1));

figure(1)
imshow(I,[min(min(I)), max(max(I))]);

[x1,y1] = (ginput(1));
[x2,y2] = (ginput(1));
x1 = round(x1)
x2 = round(x2)
y1 = round(y1)
y2 = round(y2)
roisz = 6;
ind2 = 1;
iterat = 100;
stepsize = 50;
limit = 1000;
Presx = 0;
Presy = 0;
counts = 0;
bg = 0;
sigx  = 0;
sigy = 0;
for i=1:nof
    i
    filename = files(i).name;
    I=double(myimread(filename,fmt_s));
    imr = (I(y2:y1, x1:x2));
    [xz,yz,xzz,yzz] = centerofmass(imr);
    xz1 = xz-roisz;
    xz2 = xz+roisz;
    yz1 = yz-roisz;
    yz2 = yz+roisz;
    imreg = imr(yz1:yz2, xz1:xz2);
%     figure(2)
%     imshow(imreg,[min(min(imreg)), max(max(imreg))]);
    imstack(:,:,ind2) = imreg;
    
    
    if(ind2*iterat > limit)
        ind2 = 0;
        imst=dip_Image(imstack);
        [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
        Presx = [Presx;P(:,1)];
        Presy = [Presy;P(:,2)];
        counts = [counts;P(:,3)];
        bg = [bg;P(:,4)];
        sigx = [sigx;P(:,5)];
        sigy = [sigy;P(:,6)];
        clear P imstack imst;
    end
    
    
    
    ind2 = ind2 + 1;
end

if(ind2>1)
    imst=dip_Image(imstack);
    [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
    Presx = [Presx;P(:,1)];
    Presy = [Presy;P(:,2)];
    counts = [counts;P(:,3)];
    bg = [bg;P(:,4)];
    sigx = [sigx;P(:,5)];
    sigy = [sigy;P(:,6)];
end

in = 1;
for j=1:nof/stfr
    
    for jj=1:stfr
        
        if(jj==1)
            nsigx(in) = 0;
            nsigy(in) = 0;
        end
        
        nsigx(in) = nsigx(in) + sigx(((j-1)*stfr)+jj);
        nsigy(in) = nsigy(in) + sigy(((j-1)*stfr)+jj);
        
    end
    nsigx(in) = nsigx(in) / stfr;
    nsigy(in) = nsigy(in) / stfr;
    
    yval(in) = (in*stepsize);
    in = in + 1;
    
end

xval = nsigx-nsigy;


figure(1)
plot(yval,nsigx);
hold on;
plot(yval,nsigy,'color','red');

figure(3)
plot(xval,yval,'+');

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

%% Fit
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global xval yval p
global nxval nyval x y rb lb

polorder = str2num(get(handles.edit2,'String'));
lb = str2num(get(handles.edit3,'String'));
rb = str2num(get(handles.edit4,'String'));
in = 1;
calibfile = fopen('C:\Users\juergen\Desktop\results\calib.dat','w');
for i=1:length(yval)
    if((yval(i) >= lb) && (yval(i) <= rb))
        nxval(in) = xval(i);
        nyval(in) = yval(i);
        in = in + 1;
    end
end

p = polyfit(nxval,nyval,polorder);

x = min(nxval):0.01:max(nxval);
y = polyval(p,x);

clf(figure(4));

figure(4)
plot(nxval,nyval,'+');
hold on;
plot(x,y,'color','red');

for j=1:length(nxval)
    
    fprintf(calibfile,'%6.5f\t %6.5f\n',nxval(j),nyval(j));
    
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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Test Steps
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

warning off;

global p

foldername = get(handles.edit5,'String');

fmt_s = imformats('tif');
cd(foldername)
out = uipickfiles;
directo = out{1};
cd(directo);
files = dir('*.tif');
nof = length(files);
filename = files(round(nof/2)).name;
I=double(myimread(filename,fmt_s));

clf(figure(1));

figure(1)
imshow(I,[min(min(I)), max(max(I))]);

[x1,y1] = (ginput(1));
[x2,y2] = (ginput(1));
x1 = round(x1)
x2 = round(x2)
y1 = round(y1)
y2 = round(y2)
roisz = 6;
ind2 = 1;
iterat = 30;
stepsize = 50;
limit = 1000;
Presx = 0;
Presy = 0;
counts = 0;
bg = 0;
sigx  = 0;
sigy = 0;

for i=1:nof
    i
    filename = files(i).name;
    I=double(myimread(filename,fmt_s));
    imr = (I(y2:y1, x1:x2));
    [xz,yz,xzz,yzz] = centerofmass(imr);
    xz1 = xz-roisz;
    xz2 = xz+roisz;
    yz1 = yz-roisz;
    yz2 = yz+roisz;
    imreg = imr(yz1:yz2, xz1:xz2);
%     figure(2)
%     imshow(imreg,[min(min(imreg)), max(max(imreg))]);
    imstack(:,:,ind2) = imreg;
    
    
    if(ind2*iterat > limit)
        ind2 = 0;
        imst=dip_Image(imstack);
        [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
        Presx = [Presx;P(:,1)];
        Presy = [Presy;P(:,2)];
        counts = [counts;P(:,3)];
        bg = [bg;P(:,4)];
        sigx = [sigx;P(:,5)];
        sigy = [sigy;P(:,6)];
        clear P imstack imst;
    end
    
    
    
    ind2 = ind2 + 1;
end

if(ind2>1)
    imst=dip_Image(imstack);
    [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
    Presx = [Presx;P(:,1)];
    Presy = [Presy;P(:,2)];
    counts = [counts;P(:,3)];
    bg = [bg;P(:,4)];
    sigx = [sigx;P(:,5)];
    sigy = [sigy;P(:,6)];
end

for j=1:length(sigx)
    %[z,D]=getz(sigx(j),sigy(j),p,lb,rb);
    zval(j) = polyval(p,sigx(j)-sigy(j));
end

figure(5)
plot(zval);

stepsexport = fopen('calib.dat','w');

for j=1:length(zval)
    fprintf(stepsexport,'%6.5f\n',zval(j));    
end

fclose(stepsexport);

in = 1;
for t=300:900
    nzval(in) = zval(t);
    in = in + 1;
end

figure(6);
hist(zval,600);

figure(7);
hist(nzval,600);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
