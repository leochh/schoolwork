classdef code < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure       matlab.ui.Figure         % UI Figure
        LabelSlider    matlab.ui.control.Label  % 100Hz
        Slider1        matlab.ui.control.Slider % [-40 10]
        Label          matlab.ui.control.Label  % 300Hz
        Slider2        matlab.ui.control.Slider % [-40 10]
        Label2         matlab.ui.control.Label  % 600Hz
        Slider3        matlab.ui.control.Slider % [-40 10]
        Label3         matlab.ui.control.Label  % 1.2kHz
        Slider4        matlab.ui.control.Slider % [-40 10]
        Label4         matlab.ui.control.Label  % 2.4kHz
        Slider5        matlab.ui.control.Slider % [-40 10]
        Label5         matlab.ui.control.Label  % 4.8kHz
        Slider6        matlab.ui.control.Slider % [-40 10]
        Label6         matlab.ui.control.Label  % 9.35kHz
        Slider7        matlab.ui.control.Slider % [-40 10]
        Label7         matlab.ui.control.Label  % 17.15kHz
        Slider8        matlab.ui.control.Slider % [-40 10]
        btn_plot       matlab.ui.control.Button % Plot Freq Resp
        Label8         matlab.ui.control.Label  % 0
        Label9         matlab.ui.control.Label  % 0
        Label10        matlab.ui.control.Label  % 0
        Label11        matlab.ui.control.Label  % 0
        Label12        matlab.ui.control.Label  % 0
        Label13        matlab.ui.control.Label  % 0
        Label14        matlab.ui.control.Label  % 0
        Label15        matlab.ui.control.Label  % 0
        btn_load       matlab.ui.control.Button % Load
        Label16        matlab.ui.control.Label  % File Name
        Label17        matlab.ui.control.Label  % File Path
        btn_play       matlab.ui.control.Button % Play
        btn_stop       matlab.ui.control.Button % Stop
        btn_reset      matlab.ui.control.Button % Reset
        btn_apply      matlab.ui.control.Button % Apply
        btn_plotSample matlab.ui.control.Button % Plot Time v Sample
        btn_plotFreq   matlab.ui.control.Button % Plot Freq Spectrum
        btn_plot2      matlab.ui.control.Button % Plot Imp Resp
        btn_plotIdeal  matlab.ui.control.Button % Plot Ideal Freq Resp
    end


    properties (Access = private)
        bandGain = (zeros(1,8)) % Description
        sampleData % Description
        sampleRate % Description
        coef_fir2 % Description
        filteredData % Description
    end

    methods (Access = private)

        function b = filtering(app)
            Fsamp = 44100;
            fpts = [0 199 200 399 400 799 800 1599 1600 3199 3200 6399 6400 12299 12300 22000 22001 Fsamp/2]/(Fsamp/2); 
            v = 10.^(app.bandGain/20);
            mval = [v(1) v(1) v(2) v(2) v(3) v(3) v(4) v(4) v(5) v(5) v(6) v(6) v(7) v(7) v(8) v(8) 0 0];
            N = 511;
            b = fir2(N, fpts, mval, chebwin(N+1));
        end

        function sn = signalNorm(app, s)
            ss = s(:, 1); 
            sn = ss;
        end

    end


    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.coef_fir2 = filtering(app);
        end

        % Slider1 value changed function
        function Slider1ValueChanged(app)
            value = round(app.Slider1.Value,1);
            app.Label8.Text = num2str(value, 2);
            app.bandGain(1) = value;
        end

        % Slider2 value changed function
        function Slider2ValueChanged(app)
            value = round(app.Slider2.Value,1);
            app.Label9.Text = num2str(value,2);
            app.bandGain(2) = value;
        end

        % Slider3 value changed function
        function Slider3ValueChanged(app)
            value = round(app.Slider3.Value,1);
            app.Label10.Text = num2str(value,2);
            app.bandGain(3) = value;
        end

        % Slider4 value changed function
        function Slider4ValueChanged(app)
            value = round(app.Slider4.Value,1);
            app.Label11.Text = num2str(value,2);
            app.bandGain(4) = value;
        end

        % Slider5 value changed function
        function Slider5ValueChanged(app)
            value = round(app.Slider5.Value,1);
            app.Label12.Text = num2str(value,2);
            app.bandGain(5) = value;
        end

        % Slider6 value changed function
        function Slider6ValueChanged(app)
            value = round(app.Slider6.Value,1);
            app.Label13.Text = num2str(value,2);
            app.bandGain(6) = value;
        end

        % Slider7 value changed function
        function Slider7ValueChanged(app)
            value = round(app.Slider7.Value,1);
            app.Label14.Text = num2str(value,2);
            app.bandGain(7) = value;
        end

        % Slider8 value changed function
        function Slider8ValueChanged(app)
            value = round(app.Slider8.Value,1);
            app.Label15.Text = num2str(value,2);
            app.bandGain(8) = value;
        end

        % btn_plot button pushed function
        function btn_plotButtonPushed(app)
            app.coef_fir2 = filtering(app);
            Fs = 44100;
            [H, w] = freqz(app.coef_fir2, 1, 512);
            plot(w*Fs/(2*pi), 20*log10(abs(H)));
        end

        % btn_load button pushed function
        function btn_loadButtonPushed(app)
            [fileName, filePath] = uigetfile('*.wav', 'Select input audio file(.wav)');
            try
            app.Label16.Text = fileName;
            app.Label17.Text = filePath;
            [app.sampleData, app.sampleRate] = audioread(fullfile(filePath, fileName));
            app.filteredData = filter(app.coef_fir2, 1, app.sampleData);
            end
        end

        % btn_play button pushed function
        function btn_playButtonPushed(app)
            sound(app.filteredData, app.sampleRate);
        end

        % btn_stop button pushed function
        function btn_stopButtonPushed(app)
            clear sound;
        end

        % btn_reset button pushed function
        function btn_resetButtonPushed(app)
            app.Slider1.Value = 0;
            app.Slider2.Value = 0;
            app.Slider3.Value = 0;
            app.Slider4.Value = 0;
            app.Slider5.Value = 0;
            app.Slider6.Value = 0;
            app.Slider7.Value = 0;
            app.Slider8.Value = 0;
            app.Label8.Text = '0';
            app.Label9.Text = '0';
            app.Label10.Text = '0';
            app.Label11.Text = '0';
            app.Label12.Text = '0';
            app.Label13.Text = '0';
            app.Label14.Text = '0';
            app.Label15.Text = '0';
            app.bandGain = (zeros(1,8));
        end

        % btn_apply button pushed function
        function btn_applyButtonPushed(app)
            app.coef_fir2 = filtering(app);
            app.filteredData = filter(app.coef_fir2, 1, app.sampleData);
        end

        % btn_plotSample button pushed function
        function btn_plotSampleButtonPushed(app)
            Fs = app.sampleRate;
            t = (1:10*Fs)/Fs;
            
            ax1 = subplot(2,1,1);
            plot(ax1, t, app.sampleData(1:10*Fs), 'r');
            title(ax1,'Input');
            xlabel(ax1,'Time (seconds)');
            ylabel(ax1,'Time waveform');
            
            ax2 = subplot(2,1,2);
            plot(ax2, t, app.filteredData(1:10*Fs), 'b');
            title(ax2,'Output');
            xlabel(ax2,'Time (seconds)');
            ylabel(ax2,'Time waveform');
            
            axis([ax1 ax2],[0 10 -0.5 0.5]);
        end

        % btn_plotFreq button pushed function
        function btn_plotFreqButtonPushed(app)
            s = signalNorm(app, app.sampleData);
            sf = signalNorm(app, app.filteredData);
            Fs = app.sampleRate;
            nf = length(s);
            S = 20*log10(fft(s, nf)/nf);
            SF = 20*log10(fft(sf, nf)/nf);
            w = (0:nf/2-1)/(nf/2)*(Fs/2);
            
            ax1 = subplot(2,1,1);
            plot(ax1, w, S(1:nf/2), 'r');
            title(ax1,'Input');
            xlabel(ax1,'Frequency (Hz)');
            ylabel(ax1,'Mag. of Fourier Transform');
            
            ax2 = subplot(2,1,2);
            plot(ax2, w, SF(1:nf/2), 'b');
            title(ax2,'Output');
            xlabel(ax2,'Frequency (Hz)');
            ylabel(ax2,'Mag. of Fourier Transform');
            
            axis([ax1 ax2],[0 24000 -200 0]);
        end

        % btn_plot2 button pushed function
        function btn_plot2ButtonPushed(app)
            app.coef_fir2 = filtering(app);
            b = app.coef_fir2;
            Fs = 44100;
            [h,t] = impz(b,1,[],Fs);
            plot(t, h);
            xlabel('Time (seconds)');
            ylabel('Impulse Resp');
        end

        % btn_plotIdeal button pushed function
        function btn_plotIdealButtonPushed(app)
            Fsamp = 44100;
            fpts = [0 199 200 399 400 799 800 1599 1600 3199 3200 6399 6400 12299 12300 22000 22001 Fsamp/2];
            v = app.bandGain;
            mval = [v(1) v(1) v(2) v(2) v(3) v(3) v(4) v(4) v(5) v(5) v(6) v(6) v(7) v(7) v(8) v(8) -40 -40];
            plot(fpts,mval);
            axis([0 24000 -50 15]);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 714 510];
            app.UIFigure.Name = 'UI Figure';
            setAutoResize(app, app.UIFigure, true)

            % Create LabelSlider
            app.LabelSlider = uilabel(app.UIFigure);
            app.LabelSlider.HorizontalAlignment = 'right';
            app.LabelSlider.Position = [34 435 35 15];
            app.LabelSlider.Text = '100Hz';

            % Create Slider1
            app.Slider1 = uislider(app.UIFigure);
            app.Slider1.Limits = [-40 10];
            app.Slider1.Orientation = 'vertical';
            app.Slider1.ValueChangedFcn = createCallbackFcn(app, @Slider1ValueChanged);
            app.Slider1.FontWeight = 'bold';
            app.Slider1.FontColor = [1 0 0];
            app.Slider1.Position = [50 269 3 160];

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [110 435 35 15];
            app.Label.Text = '300Hz';

            % Create Slider2
            app.Slider2 = uislider(app.UIFigure);
            app.Slider2.Limits = [-40 10];
            app.Slider2.Orientation = 'vertical';
            app.Slider2.ValueChangedFcn = createCallbackFcn(app, @Slider2ValueChanged);
            app.Slider2.FontWeight = 'bold';
            app.Slider2.FontColor = [1 0 0];
            app.Slider2.Position = [126 269 3 160];

            % Create Label2
            app.Label2 = uilabel(app.UIFigure);
            app.Label2.HorizontalAlignment = 'right';
            app.Label2.Position = [186 435 35 15];
            app.Label2.Text = '600Hz';

            % Create Slider3
            app.Slider3 = uislider(app.UIFigure);
            app.Slider3.Limits = [-40 10];
            app.Slider3.Orientation = 'vertical';
            app.Slider3.ValueChangedFcn = createCallbackFcn(app, @Slider3ValueChanged);
            app.Slider3.FontWeight = 'bold';
            app.Slider3.FontColor = [1 0 0];
            app.Slider3.Position = [202 269 3 160];

            % Create Label3
            app.Label3 = uilabel(app.UIFigure);
            app.Label3.HorizontalAlignment = 'right';
            app.Label3.Position = [262 435 37 15];
            app.Label3.Text = '1.2kHz';

            % Create Slider4
            app.Slider4 = uislider(app.UIFigure);
            app.Slider4.Limits = [-40 10];
            app.Slider4.Orientation = 'vertical';
            app.Slider4.ValueChangedFcn = createCallbackFcn(app, @Slider4ValueChanged);
            app.Slider4.FontWeight = 'bold';
            app.Slider4.FontColor = [1 0 0];
            app.Slider4.Position = [279 269 3 160];

            % Create Label4
            app.Label4 = uilabel(app.UIFigure);
            app.Label4.HorizontalAlignment = 'right';
            app.Label4.Position = [339 435 37 15];
            app.Label4.Text = '2.4kHz';

            % Create Slider5
            app.Slider5 = uislider(app.UIFigure);
            app.Slider5.Limits = [-40 10];
            app.Slider5.Orientation = 'vertical';
            app.Slider5.ValueChangedFcn = createCallbackFcn(app, @Slider5ValueChanged);
            app.Slider5.FontWeight = 'bold';
            app.Slider5.FontColor = [1 0 0];
            app.Slider5.Position = [356 269 3 160];

            % Create Label5
            app.Label5 = uilabel(app.UIFigure);
            app.Label5.HorizontalAlignment = 'right';
            app.Label5.Position = [423 435 37 15];
            app.Label5.Text = '4.8kHz';

            % Create Slider6
            app.Slider6 = uislider(app.UIFigure);
            app.Slider6.Limits = [-40 10];
            app.Slider6.Orientation = 'vertical';
            app.Slider6.ValueChangedFcn = createCallbackFcn(app, @Slider6ValueChanged);
            app.Slider6.FontWeight = 'bold';
            app.Slider6.FontColor = [1 0 0];
            app.Slider6.Position = [436 269 3 160];

            % Create Label6
            app.Label6 = uilabel(app.UIFigure);
            app.Label6.HorizontalAlignment = 'right';
            app.Label6.Position = [488 435 44 15];
            app.Label6.Text = '9.35kHz';

            % Create Slider7
            app.Slider7 = uislider(app.UIFigure);
            app.Slider7.Limits = [-40 10];
            app.Slider7.Orientation = 'vertical';
            app.Slider7.ValueChangedFcn = createCallbackFcn(app, @Slider7ValueChanged);
            app.Slider7.FontWeight = 'bold';
            app.Slider7.FontColor = [1 0 0];
            app.Slider7.Position = [512 269 3 160];

            % Create Label7
            app.Label7 = uilabel(app.UIFigure);
            app.Label7.HorizontalAlignment = 'right';
            app.Label7.Position = [571 435 51 15];
            app.Label7.Text = '17.15kHz';

            % Create Slider8
            app.Slider8 = uislider(app.UIFigure);
            app.Slider8.Limits = [-40 10];
            app.Slider8.Orientation = 'vertical';
            app.Slider8.ValueChangedFcn = createCallbackFcn(app, @Slider8ValueChanged);
            app.Slider8.FontWeight = 'bold';
            app.Slider8.FontColor = [1 0 0];
            app.Slider8.Position = [595 269 3 160];

            % Create btn_plot
            app.btn_plot = uibutton(app.UIFigure, 'push');
            app.btn_plot.ButtonPushedFcn = createCallbackFcn(app, @btn_plotButtonPushed);
            app.btn_plot.Position = [186 145 118 22];
            app.btn_plot.Text = 'Plot Freq Resp';

            % Create Label8
            app.Label8 = uilabel(app.UIFigure);
            app.Label8.Position = [50 248 41 15];
            app.Label8.Text = '0';

            % Create Label9
            app.Label9 = uilabel(app.UIFigure);
            app.Label9.Position = [126 247 41 15];
            app.Label9.Text = '0';

            % Create Label10
            app.Label10 = uilabel(app.UIFigure);
            app.Label10.Position = [202 247 41 15];
            app.Label10.Text = '0';

            % Create Label11
            app.Label11 = uilabel(app.UIFigure);
            app.Label11.Position = [279 248 41 15];
            app.Label11.Text = '0';

            % Create Label12
            app.Label12 = uilabel(app.UIFigure);
            app.Label12.Position = [356 247 41 15];
            app.Label12.Text = '0';

            % Create Label13
            app.Label13 = uilabel(app.UIFigure);
            app.Label13.Position = [436 248 39 15];
            app.Label13.Text = '0';

            % Create Label14
            app.Label14 = uilabel(app.UIFigure);
            app.Label14.Position = [512 247 41 15];
            app.Label14.Text = '0';

            % Create Label15
            app.Label15 = uilabel(app.UIFigure);
            app.Label15.Position = [595 247 41 15];
            app.Label15.Text = '0';

            % Create btn_load
            app.btn_load = uibutton(app.UIFigure, 'push');
            app.btn_load.ButtonPushedFcn = createCallbackFcn(app, @btn_loadButtonPushed);
            app.btn_load.Position = [522 179 100 22];
            app.btn_load.Text = 'Load';

            % Create Label16
            app.Label16 = uilabel(app.UIFigure);
            app.Label16.Position = [247 61 213 15];
            app.Label16.Text = 'File Name';

            % Create Label17
            app.Label17 = uilabel(app.UIFigure);
            app.Label17.Position = [247 40 213 15];
            app.Label17.Text = 'File Path';

            % Create btn_play
            app.btn_play = uibutton(app.UIFigure, 'push');
            app.btn_play.ButtonPushedFcn = createCallbackFcn(app, @btn_playButtonPushed);
            app.btn_play.Position = [522 145 100 22];
            app.btn_play.Text = 'Play';

            % Create btn_stop
            app.btn_stop = uibutton(app.UIFigure, 'push');
            app.btn_stop.ButtonPushedFcn = createCallbackFcn(app, @btn_stopButtonPushed);
            app.btn_stop.Position = [522 112 100 22];
            app.btn_stop.Text = 'Stop';

            % Create btn_reset
            app.btn_reset = uibutton(app.UIFigure, 'push');
            app.btn_reset.ButtonPushedFcn = createCallbackFcn(app, @btn_resetButtonPushed);
            app.btn_reset.Position = [45 124 100 22];
            app.btn_reset.Text = 'Reset';

            % Create btn_apply
            app.btn_apply = uibutton(app.UIFigure, 'push');
            app.btn_apply.ButtonPushedFcn = createCallbackFcn(app, @btn_applyButtonPushed);
            app.btn_apply.Position = [45 156 100 22];
            app.btn_apply.Text = 'Apply';

            % Create btn_plotSample
            app.btn_plotSample = uibutton(app.UIFigure, 'push');
            app.btn_plotSample.ButtonPushedFcn = createCallbackFcn(app, @btn_plotSampleButtonPushed);
            app.btn_plotSample.Position = [356 124 112 22];
            app.btn_plotSample.Text = 'Plot Time v Sample';

            % Create btn_plotFreq
            app.btn_plotFreq = uibutton(app.UIFigure, 'push');
            app.btn_plotFreq.ButtonPushedFcn = createCallbackFcn(app, @btn_plotFreqButtonPushed);
            app.btn_plotFreq.Position = [356 156 111 22];
            app.btn_plotFreq.Text = 'Plot Freq Spectrum';

            % Create btn_plot2
            app.btn_plot2 = uibutton(app.UIFigure, 'push');
            app.btn_plot2.ButtonPushedFcn = createCallbackFcn(app, @btn_plot2ButtonPushed);
            app.btn_plot2.Position = [186 111 118 22];
            app.btn_plot2.Text = 'Plot Imp Resp';

            % Create btn_plotIdeal
            app.btn_plotIdeal = uibutton(app.UIFigure, 'push');
            app.btn_plotIdeal.ButtonPushedFcn = createCallbackFcn(app, @btn_plotIdealButtonPushed);
            app.btn_plotIdeal.Position = [186 180 118 22];
            app.btn_plotIdeal.Text = 'Plot Ideal Freq Resp';
        end
    end

    methods (Access = public)

        % Construct app
        function app = myequalizer()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end