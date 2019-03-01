package clock;

import javafx.geometry.Pos;
import javafx.scene.control.Label;
import javafx.scene.layout.BorderPane;
import javafx.scene.text.Font;

public class AppleClockWithTitle extends BorderPane {

	private Label cityLabel = null;
	private AppleClockPane clock = null;
	
	private String city = null;

	public AppleClockWithTitle(String city) {
		this.city = city;
		initialize();
	}
	
	void initialize() {
		cityLabel = new Label(city);
		
		clock = new AppleClockPane();

		this.setTop(cityLabel);
		this.setAlignment(cityLabel, Pos.TOP_CENTER);
		cityLabel.setFont(new Font("Arial", 20));
		this.setCenter(clock);
		
	}
	
	ClockPane getClock() {
		return clock;
	}
}
