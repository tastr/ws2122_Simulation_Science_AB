%% dialog box
function [out1, out2] = aux_PSODialogBox(varargin)

	% get information about screen size
		%Sets the units of your root object (screen) to pixels
		set(0,'units','pixels');
		%Obtains this pixel information
		Pix_SS = get(0,'screensize');
		% dialog position
		dlgX = Pix_SS(3)*(.75/5);
		dlgY = Pix_SS(4)*(3/5);
		
% dialog size
dlgW = 350;
dlgH = 300;
% button size
btnW = 70;
btnH = 25;

% input arguments
switch nargin
	case 3
		missingSigName	= varargin{1};
		missingUnits	= varargin{2};
		measData		= varargin{3};
	otherwise
		error('err:nargin','ERROR:\nWrong number of input arguments.')
end

% collect information
	dlgName = ['Missing Signal: ',missingSigName];
		strDlg = {['There is no ',upper(missingSigName),' in this measurement,'],...
			'or does not have the standard naming.',' ',...
			['Please select the ',missingSigName,'s signal'],...
			'and its UNIT from the list below:'};
		listStr = fieldnames(measData);
		
% create dialog
d			= dialog('Position',[dlgX dlgY dlgW dlgH],'Name',dlgName);
txt			= uicontrol('Parent',d,...
				'Style','text',...
				'Position',[0 dlgH*7/10 dlgW dlgH*3/10],...
				'String',strDlg);
listSignals	= uicontrol('Parent',d,...
				'Style','list',...
				'Position',[dlgW*.5/10 dlgH*2.5/10 dlgW*6/10 dlgH/2],...
				'String',listStr,...
				'Callback',@listSignalsCallback);			
listUnits	= uicontrol('Parent',d,...
				'Style','list',...
				'Position',[dlgW*7/10 dlgH*2.5/10 dlgW*2.5/10 dlgH/2],...
				'String',missingUnits,...
				'Callback',@listUnitsCallback);				
btnOk		= uicontrol('Parent',d,...
				'Position',[dlgW/10 20 btnW btnH],...
				'String','Ok',...
				'Callback','delete(gcf)');
btnCancel	= uicontrol('Parent',d,...
				'Position',[dlgW*9/10-btnW 20 btnW btnH],...
				'String','Cancel',...
				'Callback',@btnCancelCallback);
			
% define default outputs
listSignalsCallback(listSignals)
listUnitsCallback(listUnits)

% Wait for user input
uiwait(d);

%% callback functions
	function listSignalsCallback(list,event)
		idx = list.Value;
		listItems = list.String;
		out1 = char(listItems(idx,:));
	end

	function listUnitsCallback(list,event)
		idx = list.Value;
		listItems = list.String;
		out2 = char(listItems(idx,:));
	end

	function btnCancelCallback(foo,event)
		out1 = [];
		out2 = [];
		delete(gcf);
	end
end
