package com.example.gameserver.model;  // Mine differs a bit from the original snippet I need to include main here

import jakarta.persistence.*;
@Entity
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private float x;
    private float y;

    public Player() {}

    public Player(String name, float x, float y) {
        this.name = name;
        this.x = x;
        this.y = y;
    }

    // Make the getters and setter under ere

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getX() {
        return x;
    }

    public void setX(float x) {
        this.x = x;
    }

    public float getY() {
        return y;
    }

    public void setY(float y) {
        this.y = y;
    }
}
