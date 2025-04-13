package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/public-awesome/stargaze/v16/x/alloc/types"
)

func (k msgServer) FundFairburnPool(goCtx context.Context, msg *types.MsgFundFairburnPool) (*types.MsgFundFairburnPoolResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	sender, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		return nil, err
	}
	err = k.sendToFairburnPool(ctx, sender, msg.Amount)
	if err != nil {
		return nil, err
	}
	ctx.EventManager().EmitEvents(sdk.Events{
		sdk.NewEvent(
			types.EventTypeFundFairburnPool,
			sdk.NewAttribute(sdk.AttributeKeyAmount, msg.Amount.String()),
		),
	})
	return &types.MsgFundFairburnPoolResponse{}, nil
}
