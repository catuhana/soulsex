# TODO: Find a way to deduplicate this module.
# Idea: messages themselves define the codes.
defmodule Soulseek.Server.Codes do
  @moduledoc """
  Registry of server message codes mapped to their message modules.

  The code keys a message's namespace module (e.g. `Soulseek.Server.Login`);
  resolving the `Request`/`Response` variant for a given direction is the
  caller's concern.
  """

  @codes %{
    1 => Soulseek.Server.Login,
    2 => Soulseek.Server.SetWaitPort,
    3 => Soulseek.Server.GetPeerAddress,
    5 => Soulseek.Server.WatchUser,
    6 => Soulseek.Server.UnwatchUser,
    7 => Soulseek.Server.GetUserStatus,
    13 => Soulseek.Server.SayChatroom,
    14 => Soulseek.Server.JoinRoom,
    15 => Soulseek.Server.LeaveRoom,
    16 => Soulseek.Server.UserJoinedRoom,
    17 => Soulseek.Server.UserLeftRoom,
    18 => Soulseek.Server.ConnectToPeer,
    22 => Soulseek.Server.MessageUser,
    23 => Soulseek.Server.MessageAcked,
    26 => Soulseek.Server.FileSearch,
    28 => Soulseek.Server.SetStatus,
    32 => Soulseek.Server.ServerPing,
    35 => Soulseek.Server.SharedFoldersFiles,
    36 => Soulseek.Server.GetUserStats,
    41 => Soulseek.Server.Relogged,
    42 => Soulseek.Server.UserSearch,
    51 => Soulseek.Server.AddThingILike,
    52 => Soulseek.Server.RemoveThingILike,
    54 => Soulseek.Server.Recommendations,
    56 => Soulseek.Server.GlobalRecommendations,
    57 => Soulseek.Server.UserInterests,
    64 => Soulseek.Server.RoomList,
    66 => Soulseek.Server.AdminMessage,
    69 => Soulseek.Server.PrivilegedUsers,
    71 => Soulseek.Server.HaveNoParent,
    83 => Soulseek.Server.ParentMinSpeed,
    84 => Soulseek.Server.ParentSpeedRatio,
    92 => Soulseek.Server.CheckPrivileges,
    93 => Soulseek.Server.EmbeddedMessage,
    100 => Soulseek.Server.AcceptChildren,
    102 => Soulseek.Server.PossibleParents,
    103 => Soulseek.Server.WishlistSearch,
    104 => Soulseek.Server.WishlistInterval,
    110 => Soulseek.Server.SimilarUsers,
    111 => Soulseek.Server.ItemRecommendations,
    112 => Soulseek.Server.ItemSimilarUsers,
    113 => Soulseek.Server.RoomTickers,
    114 => Soulseek.Server.RoomTickerAdded,
    115 => Soulseek.Server.RoomTickerRemoved,
    116 => Soulseek.Server.SetRoomTicker,
    117 => Soulseek.Server.AddThingIHate,
    118 => Soulseek.Server.RemoveThingIHate,
    120 => Soulseek.Server.RoomSearch,
    121 => Soulseek.Server.SendUploadSpeed,
    123 => Soulseek.Server.GivePrivileges,
    126 => Soulseek.Server.BranchLevel,
    127 => Soulseek.Server.BranchRoot,
    130 => Soulseek.Server.ResetDistributed,
    133 => Soulseek.Server.RoomMembers,
    134 => Soulseek.Server.AddRoomMember,
    135 => Soulseek.Server.RemoveRoomMember,
    136 => Soulseek.Server.CancelRoomMembership,
    137 => Soulseek.Server.CancelRoomOwnership,
    139 => Soulseek.Server.RoomMembershipGranted,
    140 => Soulseek.Server.RoomMembershipRevoked,
    141 => Soulseek.Server.EnableRoomInvitations,
    142 => Soulseek.Server.ChangePassword,
    143 => Soulseek.Server.AddRoomOperator,
    144 => Soulseek.Server.RemoveRoomOperator,
    145 => Soulseek.Server.RoomOperatorshipGranted,
    146 => Soulseek.Server.RoomOperatorshipRevoked,
    148 => Soulseek.Server.RoomOperators,
    149 => Soulseek.Server.MessageUsers,
    150 => Soulseek.Server.JoinGlobalRoom,
    151 => Soulseek.Server.LeaveGlobalRoom,
    152 => Soulseek.Server.GlobalRoomMessage,
    160 => Soulseek.Server.ExcludedSearchPhrases,
    1001 => Soulseek.Server.CantConnectToPeer,
    1003 => Soulseek.Server.CantCreateRoom
  }

  @base_modules Map.new(@codes, fn {code, module} -> {module, code} end)
  @nested_modules (for {code, base_module} <- @codes,
                       nested_suffix <- [Request, Response, Success, Failure],
                       into: %{} do
                     {Module.concat(base_module, nested_suffix), code}
                   end)

  @modules Map.merge(@base_modules, @nested_modules)

  @spec module(non_neg_integer()) :: module() | nil
  def module(code), do: Map.get(@codes, code)

  @spec code(module()) :: non_neg_integer() | nil
  def code(module), do: Map.get(@modules, module)

  @spec modules :: [module()]
  def modules, do: Map.keys(@modules)
end
