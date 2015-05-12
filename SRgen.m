function varargout = SRgen(varargin)
% SRGEN MATLAB code for SRgen.fig
%      SRGEN, by itself, creates a new SRGEN or raises the existing
%      singleton*.
%
%      H = SRGEN returns the handle to a new SRGEN or the handle to
%      the existing singleton*.
%
%      SRGEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SRGEN.M with the given input arguments.
%
%      SRGEN('Property','Value',...) creates a new SRGEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SRgen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SRgen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SRgen

% Last Modified by GUIDE v2.5 11-Dec-2013 16:24:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SRgen_OpeningFcn, ...
    'gui_OutputFcn',  @SRgen_OutputFcn, ...
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


% --- Executes just before SRgen is made visible.
function SRgen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SRgen (see VARARGIN)

% Choose default command line output for SRgen
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SRgen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SRgen_OutputFcn(hObject, eventdata, handles)
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

clear global names onames
global names onames

foldermeas = get(handles.edit3,'String');
cd(foldermeas);

names = uipickfiles;
onames = names;
for i=1:length(names)
    names{i}
    names{i} = strrep(names{i}, foldermeas, '')
end

set(handles.text1,'String',num2str(length(names)));

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global names onames
global p

fmt_s = imformats('tif');
roisz = 5;
steps = 200000;
iterat = 7;
thr = str2num(get(handles.edit1,'String'));
nrtasks = str2num(get(handles.text1,'String'));


for o=1:nrtasks
    ch3D = get(handles.checkbox1,'Value')
    %savename = ['C:\users\juergen\desktop\sim.dat'];
    savename = ['X:\',num2str(names{o}),'.dat'];
    folderres = get(handles.edit4,'String');
    res = fopen([savename],'w');
    set(handles.text6,'String',[savename]);
    cd(onames{o});
    files = dir('*.tif');
    nof = length(files);
    in = 1;
    imstack = zeros(2*roisz+1,2*roisz+1,steps);
    for j=1:nof
        if(rem(j,100)==0)
            set(handles.text7,'String',num2str(j));
            set(handles.text13,'String',num2str(100*j/nof));
            drawnow;
        end
        dat = double(myimread(files(j).name,fmt_s));
        [szx,szy] = size(dat);
        dat = dat + 1500;
        imr = forloop(dat,thr);
        CC = bwconncomp(imr);
        S = regionprops(CC,'Centroid');
        [ssx,ssy] = size(S);
             
        for i=1:ssx
            xko = S(i).Centroid(1);
            yko = S(i).Centroid(2);
            
            
            
            frnum(in) = j;
            
            xz1 = round(xko)-roisz;
            xz2 = round(xko)+roisz;
            yz1 = round(yko)-roisz;
            yz2 = round(yko)+roisz;
            
            if(xz1 > 0 && yz1 > 0 && yz2 < szx && xz2 < szy)
                imstack(:,:,in) = dat(yz1:yz2, xz1:xz2);
                Pcornerx(in) = xz1;
                Pcornery(in) = yz1;
                in = in + 1;
            end
            
            
            
            if(in > steps)
                imst=dip_Image(imstack);
                
                [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
                Presx = P(:,1) + transpose(Pcornerx);
                Presy = P(:,2) + transpose(Pcornery);
                counts = P(:,3);
                bg = P(:,4);
                sigx = P(:,5);
                sigy = P(:,6);
                
                if(ch3D == 1)
                    for t=1:length(sigx)
                        sigx(t)-sigy(t);
                        zval(t) = polyval(p,sigx(t)-sigy(t));
                        %zval(t) = (sigx(t)-sigy(t));
                    end
                else
                    zval = 0*sigx;
                end
                
                
                
                for e=1:length(Presx)
                    
                    fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f\n',Presx(e,1),Presy(e,1), frnum(e), counts(e,1), bg(e,1), 0.01*zval(e), sigx(e), sigy(e));
                    
                end
                
                in = 1;
                clear Presx Presy P CRLB LL ET Pcornerx Pcornery imstack frnum;
            end
            
            
        end
        
    end
    
    if(in > 1)
        imstack = imstack(:,:,1:in-1);
        imst=dip_Image(imstack);
        
        [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
        Presx = P(:,1) + transpose(Pcornerx);
        Presy = P(:,2) + transpose(Pcornery);
        counts = P(:,3);
        bg = P(:,4);
        sigx = P(:,5);
        sigy = P(:,6);
        
        if(ch3D == 1)
            for t=1:length(sigx)
                sigx(t)-sigy(t);
                zval(t) = polyval(p,sigx(t)-sigy(t));
                %zval(t) = (sigx(t)-sigy(t));
            end
        else
            zval = sigx.*0;
        end
        
        
        
        for e=1:length(Presx)
            
            fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f\n',Presx(e,1),Presy(e,1), frnum(e), counts(e,1), bg(e,1), 0.01*zval(e), sigx(e), sigy(e));
            
        end
        
        clear Presx Presy P CRLB LL ET Pcornerx Pcornery imstack frnum;
        
    end
    
end

set(handles.text12,'String','done');
drawnow;

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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global p st en
global p st en
cd('c:\users\juergen\desktop\results');
drawnow;
calibname = uipickfiles;
calibdata = load(calibname{1});
set(handles.text4,'String',calibname{1});
fitorder = str2num(get(handles.edit2,'String'));
nxval = calibdata(:,1);
nyval = calibdata(:,2);
p = polyfit(nxval,nyval,fitorder);
st = min(nxval);
en = max(nxval);
x = st:0.01:en;
y = polyval(p,x);
figure(1)
plot(nxval,nyval,'+');
hold on;
plot(x,y,'color','red');
drawnow;

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


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nofmov = get(handles.edit5,'String');
fold = get(handles.edit3,'String');
name = [fold,'_',nofmov]
fmt_s = imformats('tif');
roisz = 5;
steps = 200000;
iterat = 7;
thr = str2num(get(handles.edit1,'String'));
nrtasks = 1;

set(handles.text11,'String','finding');
set(handles.text12,'String','fitting');

for o=1:nrtasks
    ch3D = get(handles.checkbox1,'Value')
    savename = [fold,'_',nofmov,'.dat']
    folderres = get(handles.edit4,'String');
    res = fopen([savename],'w');
    set(handles.text10,'String',[savename]);
    cd(name);
    files = dir('*.tif');
    nof = length(files);
    in = 1;
    imstack = zeros(2*roisz+1,2*roisz+1,steps);
    for j=1:nof
        if(rem(j,100)==0)
            set(handles.text7,'String',num2str(j));
            set(handles.text13,'String',num2str(100*j/nof));
            drawnow;
        end
        dat = double(myimread(files(j).name,fmt_s));
        [szx,szy] = size(dat);
        dat = dat + 1500;
        imr = forloop(dat,thr);
        CC = bwconncomp(imr);
        S = regionprops(CC,'Centroid');
        [ssx,ssy] = size(S);
             
        for i=1:ssx
            xko = S(i).Centroid(1);
            yko = S(i).Centroid(2);
            
            
            
            frnum(in) = j;
            
            xz1 = round(xko)-roisz;
            xz2 = round(xko)+roisz;
            yz1 = round(yko)-roisz;
            yz2 = round(yko)+roisz;
            
            if(xz1 > 0 && yz1 > 0 && yz2 < szx && xz2 < szy)
                imstack(:,:,in) = dat(yz1:yz2, xz1:xz2);
                Pcornerx(in) = xz1;
                Pcornery(in) = yz1;
                in = in + 1;
            end
            
            
            
            if(in > steps)
                imst=dip_Image(imstack);
                
                [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
                Presx = P(:,1) + transpose(Pcornerx);
                Presy = P(:,2) + transpose(Pcornery);
                counts = P(:,3);
                bg = P(:,4);
                sigx = P(:,5);
                sigy = P(:,6);
                
                if(ch3D == 1)
                    parfor t=1:length(sigx)
                        zval(t) = polyval(p,sigx(t)-sigy(t));
                    end
                else
                    zval = 0*sigx;
                end
                
                
                
                for e=1:length(Presx)
                    
                    fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f\n',Presx(e,1),Presy(e,1), frnum(e), counts(e,1), bg(e,1), zval(e), sigx(e), sigy(e));
                    
                end
                
                in = 1;
                clear Presx Presy P CRLB LL ET Pcornerx Pcornery imstack frnum;
            end
            
            
        end
        
    end
    
    set(handles.text11,'String','done');
    drawnow;
    
    if(in > 1)
        imstack = imstack(:,:,1:in-1);
        imst=dip_Image(imstack);
        
        [P CRLB LL ET]=mGPUgaussMLEv2(imst,1,iterat,4);
        Presx = P(:,1) + transpose(Pcornerx);
        Presy = P(:,2) + transpose(Pcornery);
        counts = P(:,3);
        bg = P(:,4);
        sigx = P(:,5);
        sigy = P(:,6);
        
        if(ch3D == 1)
            parfor t=1:length(sigx)
                zval(t) = polyval(p,sigx(t)-sigy(t));
            end
        else
            zval = sigx.*0;
        end
        
        
        
        for e=1:length(Presx)
            
            fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f\n',Presx(e,1),Presy(e,1), frnum(e), counts(e,1), bg(e,1), zval(e), sigx(e), sigy(e));
            
        end
        
    end
    
end

set(handles.text12,'String','done');
drawnow;
set(handles.edit5,'String',num2str(str2num(nofmov)+1));

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nofmov = get(handles.edit5,'String');
set(handles.edit5,'String',num2str(str2num(nofmov)+1));

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nofmov = get(handles.edit5,'String');
set(handles.edit5,'String',num2str(str2num(nofmov)-1));

% --- Executes during object creation, after setting all properties.
function text10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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
