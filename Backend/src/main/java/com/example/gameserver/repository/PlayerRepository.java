package com.example.gameserver.repository;  // ugh now had to get rid of main when opeed from prjoect root

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.gameserver.model.Player;

public interface PlayerRepository extends JpaRepository<Player, Long> 
{
    // interface is like a blueprint ask software process lecture to go into it more

    // Apparently I dont need to write anything here unless i want custom
    // stuff and queries 



}
