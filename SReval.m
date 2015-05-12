function varargout = SReval(varargin)
% SREVAL MATLAB code for SReval.fig
%      SREVAL, by itself, creates a new SREVAL or raises the existing
%      singleton*.
%
%      H = SREVAL returns the handle to a new SREVAL or the handle to
%      the existing singleton*.
%
%      SREVAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SREVAL.M with the given input arguments.
%
%      SREVAL('Property','Value',...) creates a new SREVAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SReval_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SReval_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SReval

% Last Modified by GUIDE v2.5 15-Jan-2014 23:15:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SReval_OpeningFcn, ...
                   'gui_OutputFcn',  @SReval_OutputFcn, ...
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


% --- Executes just before SReval is made visible.
function SReval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SReval (see VARARGIN)

% Choose default command line output for SReval
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SReval wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SReval_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Open File
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global name
global name pxs resultsfolder
global imsz
global binsize
global photfilterlog ellfilterlog kosmetikfilter kosmetikfilterthr zfilter zfiltermin zfiltermax
global gain camfact photlimit elllimit

set(handles.radiobutton6,'Value',1);

imsz = str2num(get(handles.edit6,'String'));
binsize = str2num(get(handles.edit7,'String'));
photfilterlog = get(handles.radiobutton1,'Value');
gain = str2num(get(handles.edit8,'String'));
camfact = 12;
photlimit = str2num(get(handles.edit10,'String'));
ellfilterlog = get(handles.radiobutton2,'Value');
elllimit = str2num(get(handles.edit11,'String'));
kosmetikfilter = get(handles.radiobutton3,'Value');
kosmetikfilterthr = str2num(get(handles.edit12,'String'));
zfilter = get(handles.radiobutton4,'Value');
zfiltermin = str2num(get(handles.edit14,'String'));
zfiltermax = str2num(get(handles.edit15,'String'));
pxs = str2num(get(handles.edit5,'String'));

resultsfolder = get(handles.edit3,'String');

cd(resultsfolder);

out = uipickfiles;
name = out{1};
set(handles.text1,'String',name);

minv = str2num(get(handles.edit1,'String'));
maxv = str2num(get(handles.edit2,'String'));

loadshowim(name,minv,maxv,imsz,binsize,photfilterlog,gain,camfact,photlimit,ellfilterlog,elllimit,kosmetikfilter,kosmetikfilterthr,zfilter,zfiltermin,zfiltermax);

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

% get Distance
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global xdot ydot zdot

distfits = get(handles.radiobutton7,'value');

pxs = str2num(get(handles.edit5,'String'));

X(:,1) = xdot;
X(:,2) = ydot;
X(:,3) = zdot;

if(distfits == 1)
figure(20)
plot3(xdot,ydot,zdot,'.');
end
distpc = pdist(X,'euclidean');
[yhn,xhn] = hist(distpc,30);

figure(5)
clf
plot(xhn,yhn,'color','black');



figure(5)
[border,bordery] = (ginput(1));


in1 = 1;
in2 = 1;

for r=1:length(xhn)
    if(xhn(r) < border)
        lxhn(in1) = xhn(r);
        lyhn(in1) = yhn(r);
        in1 = in1 + 1;
    else
        rxhn(in2) = xhn(r);
        ryhn(in2) = yhn(r);
        in2 = in2 + 1;
    end
end
        
%% left Spot

if(distfits == 1)
    figure(7)
    clf
    plot(lxhn,lyhn,'color','green');
end

clear Starting1

Starting1(1) = max(lyhn)
Starting1(2) = mean(mean(lxhn))
Starting1(3) = std(lxhn)

options=optimset('Display','iter');
Estimates1=fminsearch(@myfitsinggauss,Starting1,options,lxhn,lyhn);

A1 = Estimates1(1)
xc1 = Estimates1(2)
st1 = Estimates1(3)

t1 = min(lxhn):0.01:max(lxhn);

if(distfits == 1)
    figure(7)
    hold on;
    plot(t1,A1*exp(-0.5*((t1-xc1)/st1).^2),'r','LineWidth',3,'color','red');
end
%% right Spot 

if(distfits == 1)
    figure(8)
    clf
    plot(rxhn,ryhn,'color','green');
end

clear Starting2

Starting2(1) = max(ryhn)
Starting2(2) = mean(mean(rxhn))
Starting2(3) = std(rxhn)


options=optimset('Display','iter');
Estimates2=fminsearch(@myfitsinggauss,Starting2,options,rxhn,ryhn);

A2 = Estimates2(1)
xc2 = Estimates2(2)
st2 = Estimates2(3)

t2 = min(rxhn):0.01:max(rxhn);

if(distfits == 1)
    figure(7)
    hold on;
    plot(t2,A2*exp(-0.5*((t2-xc2)/st2).^2),'r','LineWidth',3,'color','red');
end

%% double spot
t = xhn;
Data = yhn;

Starting(1) = A1;
Starting(2) = A2;
Starting(3) = xc2;
Starting(4) = 1/(2*xc1^2);
Starting(5) = st2;


options=optimset('Display','iter');
Estimates=fminsearch(@myfit,Starting,options,t,Data);

A1=Estimates(1)
A2=Estimates(2)
xc=Estimates(3)
b=Estimates(4)
st=Estimates(5)



distpx = pxs*xc;
set(handles.text11,'String',num2str(distpx));

figure(5)
clf
t=min(xhn):0.001:max(xhn);
plot(t,A1*t.*exp(-b*t.^2)+A2*exp(-0.5*((t-xc)/st).^2),'r','LineWidth',3,'color','red');
hold on
plot(xhn,yhn,'color','black');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global name

minv = str2num(get(handles.edit1,'String'));
maxv = str2num(get(handles.edit2,'String'));

imsz = str2num(get(handles.edit6,'String'));
binsize = str2num(get(handles.edit7,'String'));
photfilterlog = get(handles.radiobutton1,'Value');
gain = str2num(get(handles.edit8,'String'));
camfact = 12;
photlimit = str2num(get(handles.edit10,'String'));
ellfilterlog = get(handles.radiobutton2,'Value');
elllimit = str2num(get(handles.edit11,'String'));
kosmetikfilter = get(handles.radiobutton3,'Value');
kosmetikfilterthr = str2num(get(handles.edit12,'String'));
zfilter = get(handles.radiobutton4,'Value');
zfiltermin = str2num(get(handles.edit14,'String'));
zfiltermax = str2num(get(handles.edit15,'String'));

loadshowim(name,minv,maxv,imsz,binsize,photfilterlog,gain,camfact,photlimit,ellfilterlog,elllimit,kosmetikfilter,kosmetikfilterthr,zfilter,zfiltermin,zfiltermax);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global xraw yraw zraw xrawbin yrawbin pxs frn bg counts resultsfolder
clear global xdot ydot zdot scalezdot
global xdot ydot zdot scalezdot
figure(1);
[x1,y2] = (ginput(1))
[x2,y1] = (ginput(1))

only3d = get(handles.radiobutton6,'Value');

ind = 1;
for i=1:length(xraw)
    if(xrawbin(i) > x1 && yrawbin(i) > y1 && xrawbin(i) < x2 && yrawbin(i) < y2)
        xdot(ind) = xraw(i);
        ydot(ind) = yraw(i);
        zdot(ind) = zraw(i);
        frndot(ind) = frn(i);
        bgdot(ind) = bg(i);
        countsdot(ind) = counts(i);
        ind = ind + 1; 
    end    
end


axes(handles.axes1);
plot(xdot,ydot,'.');

scalezdot = zdot - mean(mean(zdot));

zdot = max(zdot)-zdot;

figure(12)
plot3(pxs*xdot,pxs*ydot,pxs*zdot,'.');
axis equal

curori = fopen([resultsfolder,'curori.txt'],'w');

for i = 1:length(xdot)
   fprintf(curori,'%6.5f\t %6.5f\t %6.5f\n', pxs*xdot(i), pxs*ydot(i), pxs*scalezdot(i));
end


stx = std(xdot)*pxs*2.3;
sty = std(ydot)*pxs*2.3;
stz = std(zdot)*pxs*2.3;

if(only3d == 0)
%     figure(17)
%     hist(zdot)
%     
%     
%     figure(18)
%     hist(xdot,50)
%     
%     
%     figure(19)
%     hist(ydot)
    
    figure(20)
    plot(frndot,pxs*zdot,'+');
   
end

set(handles.text4,'String',num2str(stx));
set(handles.text5,'String',num2str(sty));
set(handles.text17,'String',num2str(stz));

showtraces = get(handles.radiobutton5,'Value');

if(showtraces == 1)
    ytrace = zeros(max(frn),1);
    
    for i=1:length(frndot)
        ytrace(frndot(i)) = countsdot(i);
        ytracenorm(frndot(i)) = 1;
        ytracehist(i) = countsdot(i);
    end
    
    figure(3)
    plot(ytrace);
    
    figure(10)
    hist(ytracehist);
    
    figure(4)
    plot(ytracenorm);
    ylim([0 2]);
    
    mkdir([resultsfolder,'\traces\']);
    tracenumb = str2num(get(handles.edit4,'String'));
    tracename = [resultsfolder,'\traces\','trace_',num2str(tracenumb,'%09d'),'.txt'];
    tracenameor = [resultsfolder,'\traces\','traceor_',num2str(tracenumb,'%09d'),'.txt'];
    
    traceexp = fopen(tracename,'w');
    traceorexp = fopen(tracenameor,'w');
    
    for i=1:length(ytracenorm)
        fprintf(traceexp,'%5d \t %5d\n',i,ytracenorm(i));
        fprintf(traceorexp,'%5d \t %5d\n',i,ytrace(i));
    end
    
    set(handles.edit4,'String',num2str(tracenumb+1));
    
    fclose(traceexp);
    fclose(traceorexp);
end

% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
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


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global counts

gain = str2num(get(handles.edit8,'String'));
camfact = 12;

photons = (counts./gain)*camfact;

figure(11)
hist(photons,100);




function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Export
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global resultsfolder
global xdot ydot zdot pxs

figure(13)
plot3(pxs*xdot,pxs*ydot,pxs*zdot,'.');
axis equal;


orinumb = str2num(get(handles.edit4,'String'));
oriname = [resultsfolder,'\origamis\','origami_',num2str(orinumb,'%09d'),'.txt'];
set(handles.edit4,'String',num2str(orinumb+1));

oriexp = fopen(oriname,'w');

for i=1:length(xdot)
    fprintf(oriexp,'%6.5f \t %6.5f \t %6.5f \n',pxs*xdot(i),pxs*ydot(i),pxs*zdot(i));
end

fclose(oriexp);






function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global name
global name pxs resultsfolder
global imsz
global binsize
global photfilterlog ellfilterlog kosmetikfilter kosmetikfilterthr zfilter zfiltermin zfiltermax
global gain camfact photlimit elllimit


imsz = str2num(get(handles.edit6,'String'));
binsize = str2num(get(handles.edit7,'String'));
photfilterlog = get(handles.radiobutton1,'Value');
gain = str2num(get(handles.edit8,'String'));
camfact = 12;
photlimit = str2num(get(handles.edit10,'String'));
ellfilterlog = get(handles.radiobutton2,'Value');
elllimit = str2num(get(handles.edit11,'String'));
kosmetikfilter = get(handles.radiobutton3,'Value');
kosmetikfilterthr = str2num(get(handles.edit12,'String'));
zfilter = get(handles.radiobutton4,'Value');
zfiltermin = str2num(get(handles.edit14,'String'));
zfiltermax = str2num(get(handles.edit15,'String'));
pxs = str2num(get(handles.edit5,'String'));

resultsfolder = get(handles.edit3,'String');

cd(resultsfolder);

fn = get(handles.edit16,'String');
name = [resultsfolder,'_',fn,'.dat'];
set(handles.text1,'String',name);

minv = str2num(get(handles.edit1,'String'));
maxv = str2num(get(handles.edit2,'String'));

loadshowim(name,minv,maxv,imsz,binsize,photfilterlog,gain,camfact,photlimit,ellfilterlog,elllimit,kosmetikfilter,kosmetikfilterthr,zfilter,zfiltermin,zfiltermax);

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nofmov = get(handles.edit16,'String');
set(handles.edit16,'String',num2str(str2num(nofmov)+1));

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nofmov = get(handles.edit16,'String');
set(handles.edit16,'String',num2str(str2num(nofmov)-1));



% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
