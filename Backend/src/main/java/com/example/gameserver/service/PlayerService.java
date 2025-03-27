package com.example.gameserver.service;  // Ensure the package matches your structure


// Confused on what this does everything here seems that it can be implemented in Controller?
// I see that its performing CRUD ops but I dont see the point of this file other than making it easily readable
// This file was helped from my lecturer and online resources
// In my controllers for my web dev projects I usually do the CRUD ops in the controller so maybe I should do this if possible

import com.example.gameserver.model.Player;
import com.example.gameserver.repository.PlayerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PlayerService {

    private final PlayerRepository playerRepository;

    // Inject the PlayerRepository into the service
    @Autowired
    public PlayerService(PlayerRepository playerRepository) {
        this.playerRepository = playerRepository;
    }

    // Get all players
    public List<Player> getAllPlayers() {
        return playerRepository.findAll();
    }

    // Get a player by ID
    public Optional<Player> getPlayerById(Long id) {
        return playerRepository.findById(id);
    }

    // Save or update a player
    public Player savePlayer(Player player) {
        return playerRepository.save(player);
    }

    // Update player data
    public Player updatePlayer(Long id, Player player) {
        // Check if player exists
        return playerRepository.findById(id)
                .map(existingPlayer -> {
                    existingPlayer.setName(player.getName());
                    existingPlayer.setX(player.getX());
                    existingPlayer.setY(player.getY());
                    return playerRepository.save(existingPlayer);
                })
                .orElseGet(() -> {
                    player.setId(id);
                    return playerRepository.save(player);
                });
    }

    // Delete player by ID
    public void deletePlayer(Long id) {
        playerRepository.deleteById(id);
    }
}
