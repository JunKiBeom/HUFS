package clock;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.RowConstraints;
import javafx.stage.Stage;
import javafx.util.Duration;

public class AppleClockTextMain extends Application {

	@Override // Override the start method in the Application class
	public void start(Stage primaryStage) {
		AppleClockWithTitle clockNText = new AppleClockWithTitle("Seoul"); // Create a clock
		AppleClockWithTitle clockNText2 = new AppleClockWithTitle("California");

		GridPane GridPane = new GridPane();
		ColumnConstraints col1 = new ColumnConstraints();
		col1.setPercentWidth(50);
		ColumnConstraints col2 = new ColumnConstraints();
		col2.setPercentWidth(50);
		RowConstraints row = new RowConstraints();
		row.setPercentHeight(100);
		GridPane.getColumnConstraints().addAll(col1,col2);
		GridPane.getRowConstraints().add(row);
		GridPane.add(clockNText,0,0);
		GridPane.add(clockNText2,1,0);

		// Create a handler for animation
		EventHandler<ActionEvent> eventHandler = e -> {
			clockNText.getClock().setCurrentTime(); // Set a new clock time
			clockNText2.getClock().setAnotherTime();

		};

		// Create an animation for a running clock
		Timeline animation = new Timeline(new KeyFrame(Duration.millis(1000), eventHandler));
		animation.setCycleCount(Timeline.INDEFINITE);
		animation.play(); // Start animation

		// Create a scene and place it in the stage
		Scene scene = new Scene(GridPane, 500, 300);
		primaryStage.setTitle("World Clock"); // Set the stage title
		primaryStage.setScene(scene); // Place the scene in the stage
		primaryStage.show(); // Display the stage
	}

	/**
	 * The main method is only needed for the IDE with limited
	 * JavaFX support. Not needed for running from the command line.
	 */
	public static void main(String[] args) {
		launch(args);
	}
}
