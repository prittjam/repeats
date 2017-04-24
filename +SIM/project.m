            figure;
            hold on;
            plot(u(1,:),u(2,:),'b.')
            hold off;
            axis ij;
            axis equal;
            axis(0.5+[0 cam.nx 0 cam.ny]);

