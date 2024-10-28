package com.arj.dbnus

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.bumptech.glide.Glide
import android.widget.ImageView

class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        val gifImageView = findViewById<ImageView>(R.id.gifImageView)

        // Load GIF using Glide
        Glide.with(this)
            .asGif()
            .load(R.drawable.sspl_health_happiness_animation) // Replace with your GIF file in `drawable` or `raw` folder
            .into(gifImageView)

        // Delay for the splash screen (e.g., 1 second(s)) before starting main activity
        Handler(Looper.getMainLooper()).postDelayed({
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }, 1000) // 1000 ms = 1 second(s)
    }
}
