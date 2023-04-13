// Copyright Epic Games, Inc. All Rights Reserved.

#include "benchGameMode.h"
#include "benchCharacter.h"
#include "UObject/ConstructorHelpers.h"

AbenchGameMode::AbenchGameMode()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnBPClass(TEXT("/Game/ThirdPersonCPP/Blueprints/ThirdPersonCharacter"));
	if (PlayerPawnBPClass.Class != NULL)
	{
		DefaultPawnClass = PlayerPawnBPClass.Class;
	}
}
